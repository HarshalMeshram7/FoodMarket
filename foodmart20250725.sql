CREATE DATABASE  IF NOT EXISTS `foodmart` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `foodmart`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: foodmart
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `main_categories`
--

DROP TABLE IF EXISTS `main_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `main_categories` (
  `main_category_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  `display_order` int DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`main_category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_categories`
--

LOCK TABLES `main_categories` WRITE;
/*!40000 ALTER TABLE `main_categories` DISABLE KEYS */;
INSERT INTO `main_categories` VALUES (1,'Fresh Fruits','Seasonal fresh fruits','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/fruits.png',1,1,'2025-06-20 12:25:55'),(2,'Fresh Vegetables','Seasonal fresh vegetables','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/vegetables.png',2,1,'2025-06-20 12:25:55'),(3,'Dairy & Eggs','Milk, cheese, yogurt and eggs','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/dairy.png',3,1,'2025-06-20 12:25:55'),(4,'Meat & Poultry','Fresh meat and poultry products','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/meat.png',4,1,'2025-06-20 12:25:55'),(5,'Seafood','Fresh fish and shellfish','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/seafood.png',5,1,'2025-06-20 12:25:55'),(6,'Bakery','Fresh bread and pastries','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/bakery.png',6,1,'2025-06-20 12:25:55'),(7,'Beverages','Drinks for every occasion','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/beverages.png',7,1,'2025-06-20 12:25:55'),(8,'Frozen Foods','Frozen meals and ingredients','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/frozen.png',8,1,'2025-06-20 12:25:55'),(9,'Pantry Staples','Essential cooking ingredients','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/pantry.png',9,1,'2025-06-20 12:25:55'),(10,'Snacks','Chips, crackers and snack foods','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/snacks.png',10,1,'2025-06-20 12:25:55'),(11,'Organic & Natural','Certified organic products','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/organic.png',11,1,'2025-06-20 12:25:55'),(12,'International Foods','Global cuisine ingredients','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/international.png',12,1,'2025-06-20 12:25:55'),(13,'Baby & Kids','Food and essentials for children','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/baby.png',13,1,'2025-06-20 12:25:55'),(14,'Health & Wellness','Diet-specific and health foods','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/health.png',14,1,'2025-06-20 12:25:55'),(15,'Household Essentials','Cleaning and home products','https://harshal-all-projects-bucket.s3.ap-south-1.amazonaws.com/food-market/static/images/household.png',15,1,'2025-06-20 12:25:55');
/*!40000 ALTER TABLE `main_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `variant_id` int DEFAULT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `discount_amount` decimal(10,2) DEFAULT '0.00',
  PRIMARY KEY (`order_item_id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  KEY `variant_id` (`variant_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`variant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `order_number` varchar(50) NOT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','processing','shipped','delivered','cancelled') DEFAULT 'pending',
  `total_amount` decimal(10,2) NOT NULL,
  `tax_amount` decimal(10,2) DEFAULT '0.00',
  `shipping_amount` decimal(10,2) DEFAULT '0.00',
  `discount_amount` decimal(10,2) DEFAULT '0.00',
  `payment_method` varchar(50) DEFAULT NULL,
  `shipping_address` text,
  `billing_address` text,
  `notes` text,
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(64) NOT NULL,
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `used_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_token` (`token`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_expires_at` (`expires_at`),
  CONSTRAINT `password_resets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_variants`
--

DROP TABLE IF EXISTS `product_variants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_variants` (
  `variant_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `price_adjustment` decimal(10,2) DEFAULT '0.00',
  `sku` varchar(50) DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `quantity_in_stock` int DEFAULT '0',
  `is_default` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`variant_id`),
  UNIQUE KEY `sku` (`sku`),
  UNIQUE KEY `barcode` (`barcode`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variants`
--

LOCK TABLES `product_variants` WRITE;
/*!40000 ALTER TABLE `product_variants` DISABLE KEYS */;
INSERT INTO `product_variants` VALUES (1,1,'3lb Bag',5.00,'FRUIT-APP-GALA-3LB','100000000106',50,0),(2,1,'5lb Bag',8.00,'FRUIT-APP-GALA-5LB','100000000107',30,1),(3,2,'Premium Pack (4 count)',12.00,'FRUIT-APP-HONEY-4CT','100000000108',25,1),(4,3,'5lb Bag',6.00,'FRUIT-ORA-NAVEL-5LB','100000000109',40,1),(5,4,'2lb Package',6.50,'FRUIT-STRAW-2LB','100000000110',35,1),(6,5,'Pint Container',3.50,'FRUIT-BLUE-PINT','100000000111',40,1),(7,6,'3-Pack Hearts',6.00,'VEG-ROM-3PK','100000000117',30,1),(8,7,'2lb Bag',3.50,'VEG-CAR-BABY-2LB','100000000118',40,0),(9,8,'3-Pack',3.50,'VEG-CUC-3PK','100000000119',25,0),(10,9,'Red Only',0.50,'VEG-PEP-RED','100000000120',30,0),(11,9,'Yellow Only',0.50,'VEG-PEP-YELLOW','100000000121',30,1),(12,10,'Pint Container',3.00,'VEG-TOM-CHERRY-PINT','100000000122',35,1),(13,11,'1 Gallon',8.00,'DAIRY-MILK-ORG-WHOLE-GAL','100000000204',20,1),(14,12,'Vanilla Flavor',0.50,'DAIRY-MILK-ALMOND-VAN','100000000205',30,0),(15,12,'1 Gallon',5.50,'DAIRY-MILK-ALMOND-GAL','100000000206',15,1),(16,13,'Organic',1.50,'DAIRY-CREAM-HVY-ORG','100000000207',20,1),(17,14,'1lb Block',10.00,'DAIRY-CHEDDAR-SHARP-1LB','100000000211',15,1),(18,14,'Shredded',0.50,'DAIRY-CHEDDAR-SHRED','100000000212',20,0),(19,15,'1lb Ball',7.00,'DAIRY-MOZZ-1LB','100000000213',10,1),(20,15,'Shredded',0.50,'DAIRY-MOZZ-SHRED','100000000214',15,0);
/*!40000 ALTER TABLE `product_variants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `main_category_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `cost_price` decimal(10,2) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `brand` varchar(50) DEFAULT NULL,
  `weight` decimal(10,2) DEFAULT NULL,
  `weight_unit` varchar(10) DEFAULT NULL,
  `sku` varchar(50) DEFAULT NULL,
  `barcode` varchar(50) DEFAULT NULL,
  `quantity_in_stock` int DEFAULT '0',
  `min_stock_level` int DEFAULT '5',
  `is_featured` tinyint(1) DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `rating` decimal(2,1) DEFAULT NULL COMMENT 'Product rating from 1.0 to 5.0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `sku` (`sku`),
  UNIQUE KEY `barcode` (`barcode`),
  KEY `main_category_id` (`main_category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`main_category_id`) REFERENCES `main_categories` (`main_category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'Gala Apples','Sweet and crisp gala apples',2.49,1.25,'products/apple-gala.jpg','Apple Harvest',1.00,'lb','FRUIT-APP-GALA','100000000101',120,5,0,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(2,1,'Honeycrisp Apples','Premium sweet-tart apples',3.99,2.00,'products/apple-honeycrisp.jpg','Apple Harvest',1.00,'lb','FRUIT-APP-HONEY','100000000102',80,5,1,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(3,1,'Navel Oranges','Juicy seedless navel oranges',1.79,0.90,'products/orange-navel.jpg','Citrus Grove',1.00,'lb','FRUIT-ORA-NAVEL','100000000103',95,5,0,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(4,1,'Strawberries','Sweet fresh strawberries',3.99,2.00,'products/strawberries.jpg','Berry Farms',1.00,'lb','FRUIT-STRAW','100000000104',60,5,1,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(5,1,'Blueberries','Plump fresh blueberries',4.49,2.25,'products/blueberries.jpg','Berry Farms',1.00,'lb','FRUIT-BLUE','100000000105',45,5,0,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(6,2,'Romaine Lettuce','Fresh crisp romaine hearts',2.99,1.50,'products/romaine.jpg','Green Fields',1.00,'lb','VEG-ROM','100000000112',70,5,0,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(7,2,'Baby Carrots','Peeled and washed baby carrots',1.99,1.00,'products/baby-carrots.jpg','Local Farm',1.00,'lb','VEG-CAR-BABY','100000000113',85,5,0,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(8,2,'Cucumbers','Fresh English cucumbers',1.49,0.75,'products/cucumber.jpg','Green Fields',1.00,'lb','VEG-CUC','100000000114',65,5,0,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(9,2,'Bell Peppers','Mixed color bell peppers',2.49,1.25,'products/bell-peppers.jpg','Pepper Farm',1.00,'lb','VEG-PEP-BELL','100000000115',55,5,1,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(10,2,'Cherry Tomatoes','Sweet cherry tomatoes',3.49,1.75,'products/cherry-tomatoes.jpg','Tomato Valley',1.00,'lb','VEG-TOM-CHERRY','100000000116',45,5,0,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(11,3,'Organic Whole Milk','Certified organic whole milk',4.99,2.50,'products/milk-organic.jpg','Organic Valley',0.50,'gal','DAIRY-MILK-ORG-WHOLE','100000000201',40,5,1,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(12,3,'Almond Milk','Unsweetened almond milk',3.49,1.75,'products/almond-milk.jpg','Almond Breeze',0.50,'gal','DAIRY-MILK-ALMOND','100000000202',35,5,0,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(13,3,'Heavy Cream','Pure heavy whipping cream',3.99,2.00,'products/heavy-cream.jpg','DairyPure',1.00,'pt','DAIRY-CREAM-HVY','100000000203',25,5,0,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(14,3,'Sharp Cheddar','Aged sharp cheddar cheese',5.99,3.00,'products/cheddar.jpg','Cabot',8.00,'oz','DAIRY-CHEDDAR-SHARP','100000000208',30,5,0,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(15,3,'Mozzarella','Fresh mozzarella cheese',4.49,2.25,'products/mozzarella.jpg','BelGioioso',8.00,'oz','DAIRY-MOZZ','100000000209',25,5,0,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(16,6,'White Sandwich Bread','Soft white sandwich bread',2.49,1.25,'products/bread-white.jpg','Wonder',20.00,'oz','BAKERY-BREAD-WHITE','100000000020',40,5,0,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54'),(17,6,'Whole Wheat Bread','100% whole wheat bread',2.79,1.40,'products/bread-wheat.jpg','Nature\'s Own',20.00,'oz','BAKERY-BREAD-WHEAT','100000000021',35,5,0,1,4.7,'2025-06-23 05:53:01','2025-06-24 09:30:54');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `zip_code` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` timestamp NULL DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','admin@gmail.com','admin123','admin','last','9834227612','Wathoda','Nagpur','MH','440008','2025-07-22 18:30:00',NULL,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_inventory_status`
--

DROP TABLE IF EXISTS `vw_inventory_status`;
/*!50001 DROP VIEW IF EXISTS `vw_inventory_status`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_inventory_status` AS SELECT 
 1 AS `product_id`,
 1 AS `product_name`,
 1 AS `quantity_in_stock`,
 1 AS `min_stock_level`,
 1 AS `needs_restocking`,
 1 AS `main_category`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_product_catalog`
--

DROP TABLE IF EXISTS `vw_product_catalog`;
/*!50001 DROP VIEW IF EXISTS `vw_product_catalog`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_product_catalog` AS SELECT 
 1 AS `product_id`,
 1 AS `product_name`,
 1 AS `description`,
 1 AS `price`,
 1 AS `quantity_in_stock`,
 1 AS `product_image`,
 1 AS `main_category_id`,
 1 AS `main_category_name`,
 1 AS `main_category_image`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_inventory_status`
--

/*!50001 DROP VIEW IF EXISTS `vw_inventory_status`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`harshal`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_inventory_status` AS select `p`.`product_id` AS `product_id`,`p`.`name` AS `product_name`,`p`.`quantity_in_stock` AS `quantity_in_stock`,`p`.`min_stock_level` AS `min_stock_level`,(`p`.`quantity_in_stock` < `p`.`min_stock_level`) AS `needs_restocking`,`mc`.`name` AS `main_category` from (`products` `p` join `main_categories` `mc` on((`p`.`main_category_id` = `mc`.`main_category_id`))) order by (`p`.`quantity_in_stock` < `p`.`min_stock_level`) desc,`p`.`quantity_in_stock` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_product_catalog`
--

/*!50001 DROP VIEW IF EXISTS `vw_product_catalog`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`harshal`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_product_catalog` AS select `p`.`product_id` AS `product_id`,`p`.`name` AS `product_name`,`p`.`description` AS `description`,`p`.`price` AS `price`,`p`.`quantity_in_stock` AS `quantity_in_stock`,`p`.`image_url` AS `product_image`,`mc`.`main_category_id` AS `main_category_id`,`mc`.`name` AS `main_category_name`,`mc`.`image_url` AS `main_category_image` from (`products` `p` join `main_categories` `mc` on((`p`.`main_category_id` = `mc`.`main_category_id`))) where (`p`.`is_active` = true) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-25 18:50:17
