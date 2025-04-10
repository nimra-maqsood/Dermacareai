import os
import numpy as np
from flask import Flask, request, render_template, redirect, url_for, session, jsonify
from flask_mysqldb import MySQL
from werkzeug.security import generate_password_hash, check_password_hash
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image

app = Flask(__name__, static_folder='static', template_folder='templates')

# Configuring MySQL Database
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'        
app.config['MYSQL_PASSWORD'] = 'password'   
app.config['MYSQL_DB'] = 'skindisease_db'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'
mysql = MySQL(app)

# Configuring session
app.secret_key = "supersecretkey"
app.config['SESSION_TYPE'] = 'filesystem'

# Loading the skin disease model
print("DEBUG: Loading model 'densenet121.h5'...")
model = load_model("densenet121.h5")
print("DEBUG: Model loaded successfully!")


@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        print(f"DEBUG: Attempting login for user: {username}")
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM users WHERE username=%s", (username,))
        user = cur.fetchone()
        cur.close()
        if user:
            stored_password = user['password']
            if check_password_hash(stored_password, password):
                session['user_id'] = user['id']
                print(f"DEBUG: Login successful for user_id: {user['id']}")
                return redirect(url_for('index'))
            else:
                print("DEBUG: Invalid password.")
                return render_template('login.html', error="Invalid Password")
        else:
            print("DEBUG: User does not exist.")
            return render_template('login.html', error="User does not exist")
    return render_template('login.html')

@app.route('/register', methods=['POST'])
def register():
    username = request.form['username']
    email = request.form['email']
    password = request.form['password']
    print(f"DEBUG: Registering new user: {username}, email: {email}")
    hashed_password = generate_password_hash(password)
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM users WHERE username = %s OR email = %s", (username, email))
    existing_user = cur.fetchone()
    if existing_user:
        cur.close()
        print("DEBUG: Duplicate user or email found.")
        return render_template('login.html', error="Username or Email already exists. Try another.")
    cur.execute("INSERT INTO users (username, email, password) VALUES (%s, %s, %s)",
                (username, email, hashed_password))
    mysql.connection.commit()
    cur.close()
    print("DEBUG: New user registered successfully.")
    return render_template('login.html', success_register="Registration successful! You can now log in.")

@app.route('/forgot_password', methods=['POST'])
def forgot_password():
    email = request.form['email']
    new_password = request.form['new_password']
    print(f"DEBUG: Forgot password request for email: {email}")
    hashed_password = generate_password_hash(new_password)
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM users WHERE email = %s", (email,))
    user = cur.fetchone()
    if user:
        cur.execute("UPDATE users SET password = %s WHERE email = %s", (hashed_password, email))
        mysql.connection.commit()
        cur.close()
        print("DEBUG: Password updated successfully.")
        return render_template('login.html', success_forgot="Password updated successfully! You can now log in.")
    else:
        cur.close()
        print("DEBUG: Email not found in database.")
        return render_template('login.html', forgot_error="Email not found. Please register or try another email.")

@app.route('/index')
def index():
    if 'user_id' not in session:
        print("DEBUG: No user_id in session, redirecting to login.")
        return redirect(url_for('login'))
    print(f"DEBUG: User with user_id: {session['user_id']} accessing /index")
    return render_template("index.html", user_id=session['user_id'])

@app.route('/logout')
def logout():
    session.clear()
    print("DEBUG: Session cleared, user logged out.")
    return redirect(url_for('login'))


@app.route('/predict', methods=['POST'])
def upload():
    print("DEBUG: Reached /predict endpoint.")
    if 'image' not in request.files:
        print("DEBUG: No file part in request.")
        return jsonify({"error": "No file uploaded"}), 400

    f = request.files['image']
    
    temp_path = os.path.join("static", f.filename)
    print(f"DEBUG: Temporarily saving uploaded image to: {temp_path}")
    f.save(temp_path)

    # Preprocessing the image
    print("DEBUG: Loading image for prediction...")
    img = image.load_img(temp_path, target_size=(224, 224))
    x = image.img_to_array(img)
    x = np.expand_dims(x, axis=0)

    print("DEBUG: Making prediction using the model...")
    preds = model.predict(x)

    diseases = [
        'Healthy Skin', 
        'Acne', 
        'Melanoma', 
        'Actinic Keratosis', 
        'Ring worm', 
        'Eczema'
    ]
    label = np.argmax(preds, axis=1)[0]
    disease_name = diseases[label]
    print(f"DEBUG: Prediction done. Disease: {disease_name}")

    # Removing the temporary image file after prediction
    if os.path.exists(temp_path):
        os.remove(temp_path)
        print(f"DEBUG: Temporary image {temp_path} deleted.")

    # Fetching disease info from database
    cur = mysql.connection.cursor()
    print("DEBUG: Fetching disease info from database...")
    cur.execute("SELECT description, recommendation FROM disease_info WHERE disease_name = %s", (disease_name,))
    row = cur.fetchone()
    cur.close()

    if row:
        description = row['description']
        recommendation = row['recommendation']
        print("DEBUG: Found disease info in database.")
    else:
        description = "No details available in the database."
        recommendation = "Consult a dermatologist for more info."
        print("DEBUG: No disease info found in database, using fallback text.")

    # Building additional info HTML based on predicted disease
    if disease_name == "Healthy Skin":
        
        additional_info = "<p style='font-weight:bold; font-size:16px;'>Your skin appears healthy. Keep up your good routine!</p>"
    elif disease_name == "Acne":
        additional_info = ("<p style='font-weight:bold; font-size:16px;'>For more information on acne, please visit "
                           "<a href='https://dermnetnz.org/topics/acne' target='_blank'>DermNet Acne</a>. "
                           "(Note: This is a preliminary analysis. Please consult a certified dermatologist for an accurate diagnosis).</p>")
    elif disease_name == "Melanoma":
        additional_info = ("<p style='font-weight:bold; font-size:16px;'>For more information on melanoma, please visit "
                           "<a href='https://dermnetnz.org/topics/melanoma' target='_blank'>DermNet Melanoma</a>. "
                             "(Note: This is a preliminary analysis. Please consult a certified dermatologist for an accurate diagnosis).</p>")
    elif disease_name == "Actinic Keratosis":
        additional_info = ("<p style='font-weight:bold; font-size:16px;'>For more information on actinic keratosis, please visit "
                           "<a href='https://dermnetnz.org/topics/actinic-keratosis' target='_blank'>DermNet Actinic Keratosis</a>. "
                               "(Note: This is a preliminary analysis. Please consult a certified dermatologist for an accurate diagnosis).</p>")
    elif disease_name == "Ring worm":
        additional_info = ("<p style='font-weight:bold; font-size:16px;'>For more information on ringworm, please visit "
                           "<a href='https://dermnetnz.org/topics/tinea-corporis' target='_blank'>DermNet Ringworm</a>. "
                              "(Note: This is a preliminary analysis. Please consult a certified dermatologist for an accurate diagnosis).</p>")
    elif disease_name == "Eczema":
        additional_info = ("<p style='font-weight:bold; font-size:16px;'>For more information on eczema, please visit "
                           "<a href='https://dermnetnz.org/topics/discoid-eczema' target='_blank'>DermNet Discoid Eczema</a> and "
                           "<a href='https://dermnetnz.org/topics/dyshidrotic-eczema' target='_blank'>DermNet Dyshidrotic Eczema</a>. "
                             "(Note: This is a preliminary analysis. Please consult a certified dermatologist for an accurate diagnosis).</p>")
    else:
        additional_info = ""

 
    #Displaying results
    result_text = (
        f"<h3 style='font-weight:bold; font-size:18px;'>Prediction: {disease_name} </h3>"
        f"<p style='font-weight:bold; font-size:14px;'>Description: {description}</p>"
        f"<p style='font-weight:bold; font-size:14px;'>Recommendation: {recommendation}</p>"
        f"{additional_info}"
    )

    return jsonify({"prediction": result_text})

@app.route('/feedback', methods=['POST'])
def feedback():
    print("DEBUG: Reached /feedback endpoint.")
    if 'user_id' not in session:
        print("DEBUG: Feedback attempted without user_id in session.")
        return jsonify({"error": "User not logged in"}), 401

    user_id = session['user_id']
    was_correct = request.form.get('was_correct')
    rating = request.form.get('rating')
    comment = request.form.get('comment')

    print(f"DEBUG: user_id={user_id}, was_correct={was_correct}, rating={rating}, comment={comment}")

    if not was_correct:
        print("DEBUG: No was_correct value provided in feedback.")
        return jsonify({"error": "Please indicate if the result was correct."}), 400

    try:
        rating = int(rating) if rating else None
    except ValueError:
        rating = None

    cur = mysql.connection.cursor()
    cur.execute(
        "INSERT INTO feedback (user_id, was_correct, rating, comment) VALUES (%s, %s, %s, %s)",
        (user_id, was_correct, rating, comment)
    )
    mysql.connection.commit()
    cur.close()

    print("DEBUG: Feedback recorded in database.")
    return jsonify({"message": "Thank you for your feedback!"}), 200

if __name__ == '__main__':
    print("DEBUG: Starting Flask app in debug mode...")
    app.run(debug=True)
