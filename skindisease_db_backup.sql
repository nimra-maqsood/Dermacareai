-- MySQL dump 10.13  Distrib 8.0.35, for Win64 (x86_64)
--
-- Host: localhost    Database: skindisease_db
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `disease_info`
--

DROP TABLE IF EXISTS `disease_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disease_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `disease_name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `recommendation` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `disease_name` (`disease_name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disease_info`
--

LOCK TABLES `disease_info` WRITE;
/*!40000 ALTER TABLE `disease_info` DISABLE KEYS */;
INSERT INTO `disease_info` VALUES (1,'Healthy Skin','Your skin appears healthy and shows no signs of common conditions.','No treatment is necessary. Keep up a good skincare routine!'),(2,'Acne','A common skin condition that occurs when hair follicles become clogged with oil and dead skin cells.','Use benzoyl peroxide or salicylic acid products, keep the skin clean, and avoid picking at pimples.'),(3,'Melanoma','A serious form of skin cancer that arises when pigment-producing cells mutate and become cancerous.','Consult a dermatologist immediately. Surgical removal and further medical treatment may be required.'),(4,'Actinic Keratosis','A rough, scaly patch on the skin caused by years of sun exposure.','Use prescribed topical creams (e.g., 5-FU). Cryotherapy or photodynamic therapy may be necessary.'),(5,'Ring worm','A fungal infection of the skin characterized by a ring-like rash.','Apply antifungal creams or lotions, keep the area clean and dry, and wash bedding/clothing regularly.'),(6,'Eczema','A condition that makes your skin red, itchy, and inflamed.','Use moisturizers, topical steroids if prescribed, and avoid irritants. Keep skin hydrated and wear loose clothing.'),(7,'Bullous Disease','A group of blistering skin conditions, such as pemphigus or bullous pemphigoid.','Consult a dermatologist for immunosuppressants or corticosteroids. Avoid trauma to blisters.');
/*!40000 ALTER TABLE `disease_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `feedbackid` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `was_correct` enum('yes','no') NOT NULL,
  `rating` int DEFAULT NULL,
  `comment` text,
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`feedbackid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
INSERT INTO `feedback` VALUES (2,1,'yes',5,'Accurate prediction. ','2025-03-20 11:42:47'),(3,1,'yes',4,'Great App!','2025-04-06 15:54:15');
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','admin123@gmail.com','scrypt:32768:8:1$EE7EVqRyOv6HMiOy$814f146840b848448c003d0f0c9d900a46267d32f55eac5879e06799641cc77230be02c4986ad8e3977792e9cda16de8c44296487abc846f7262c37c6268d4bc'),(2,'liya','liyajohn45@gmail.com','scrypt:32768:8:1$zrtuMyq2imH2IlBk$10c71b0cc44a0b94584b0d241e23959fb578858038fe456a54f13765d1955ca3b135e04c8e8affa9538c87d0d313a46a8171f7afdf96e44087fe995e2c6d9465'),(3,'zack','zacky77@gmail.com','scrypt:32768:8:1$2ZKEVHPc6iSg0dCn$2b69165a0a138ecfc678b65ad755c7117fd60b49f2a664f067a81dff3f30a9f42062d79a07d95011e2b47a8b2f346a8ff04f7ed563140cdc192f999687611778'),(4,'Annie','annie67joe@gmail.com','scrypt:32768:8:1$r2cfuyslMYRHiRBY$87c2cd9a5c50f1fb1d8d16d27f952312cad221519f2d83208be45c08079a71b091549df964cd3871b96db67b68a4c72ae5267eddd389281a3c852879854e57dd'),(5,'Alex','alex23@gmail.com','scrypt:32768:8:1$rMQTzbv8i8FFKaG9$53521a8ec262cfd456a0e446982a5024de656199d64a41e72db8419c3e115cf618c495b2e215f255c542bd274de8f87bc32f322dc78ddbf54ce4ce32f9ce2945'),(6,'nick','nickjohn@gmail.com','scrypt:32768:8:1$YAgNkfIncWaFOTFn$6054c9feb52fc1e49ea6f4c3d142325626a3d1f70959f98177b79dd06bd429fb71cf2d58a05446c4566ae873323047298dd3f88c8fbd4360734b6daa72403830'),(7,'Eric','ericzen56@gmail.com','scrypt:32768:8:1$Is8iIeQlkrNh4125$0a25d96f72719843246f508c2af3c5cb88a250c6ead530756a1b2d75c9c5ca3794c378c489d0202e82dd42de5b8974f330fb0e42316969703c858499b9bce83f'),(8,'maryam','maryamzaid45@gmail.com','scrypt:32768:8:1$s3o3sfJkHPeAkNBE$643882a7ae8e96862e05eb4d6f2a372f941b1ccaa0278182fa8007aee62dc937e9d3a7939a5f0f0b4eaca17674b583e6f6053b8c5f80a91c379de5eab28a6f19'),(9,'Kelly','kelly488@gmail.com','scrypt:32768:8:1$yzsqAkrBIN055Ync$c11be06909a0b07156f1c9d4eb737184f5d41fb023479fbae6b78d52178365ace14e0b32c528f09d69eaef3282174f415ba3cd2b3bf53af8e096f1ff8dee92de'),(10,'Ameen','Ameenshah@gmail.com','scrypt:32768:8:1$085uSUjmb4uBuj18$98bbd6b06c3c3847c5133a187268336d5d25b0806ed9a241e5368e502343dab00732fd5afa8e2964280c0361b8d95d9c05fdb78818cca2c107ef18a27cef30af'),(11,'Nimra','nimra123@gmail.com','scrypt:32768:8:1$kqgFhCcv8pgbRMa9$6f17015ff593ef10f4d88fe79cf468b28b928cfb0c4217725cf3f00c0320ad4274bdc8ac77b43ebbc88dad5e0a10663fdbd4499bfcc7164129e39f9f0697cffd');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-10 23:08:20
