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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `main_categories`
--

LOCK TABLES `main_categories` WRITE;
/*!40000 ALTER TABLE `main_categories` DISABLE KEYS */;
INSERT INTO `main_categories` VALUES (1,'Fruits & Vegetables','Fresh produce for healthy living','categories/produce.jpg',1,1,'2025-06-16 11:59:39'),(2,'Dairy & Eggs','Milk, cheese, yogurt and eggs','categories/dairy.jpg',2,1,'2025-06-16 11:59:39'),(3,'Meat & Seafood','Fresh meat and seafood products','categories/meat.jpg',3,1,'2025-06-16 11:59:39'),(4,'Bakery','Fresh bread and pastries','categories/bakery.jpg',4,1,'2025-06-16 11:59:39'),(5,'Beverages','Drinks for every occasion','categories/beverages.jpg',5,1,'2025-06-16 11:59:39'),(6,'Frozen Foods','Frozen meals and ingredients','categories/frozen.jpg',6,1,'2025-06-16 11:59:39'),(7,'Pantry Staples','Essential cooking ingredients','categories/pantry.jpg',7,1,'2025-06-16 11:59:39'),(8,'Household','Cleaning and home essentials','categories/household.jpg',8,1,'2025-06-16 11:59:39');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variants`
--

LOCK TABLES `product_variants` WRITE;
/*!40000 ALTER TABLE `product_variants` DISABLE KEYS */;
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
  `subcategory_id` int NOT NULL,
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
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `sku` (`sku`),
  UNIQUE KEY `barcode` (`barcode`),
  KEY `subcategory_id` (`subcategory_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategories` (`subcategory_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'Red Delicious Apples','Sweet red apples, perfect for snacking',1.99,0.99,'products/apple-red.jpg','Apple Harvest',1.00,'lb','FRUIT-APP-RED','100000000001',150,5,0,1,'2025-06-16 11:59:39','2025-06-16 11:59:39'),(2,1,'Bananas','Ripe bananas, great for smoothies',0.59,0.29,'products/banana.jpg','Chiquita',1.00,'lb','FRUIT-BAN','100000000002',200,5,0,1,'2025-06-16 11:59:39','2025-06-16 11:59:39'),(3,1,'Seedless Grapes','Sweet red seedless grapes',2.99,1.50,'products/grapes.jpg','Grape Valley',1.00,'lb','FRUIT-GRAPE-RED','100000000003',75,5,0,1,'2025-06-16 11:59:39','2025-06-16 11:59:39'),(4,2,'Carrots','Fresh whole carrots',1.49,0.75,'products/carrots.jpg','Local Farm',1.00,'lb','VEG-CARROT','100000000004',120,5,0,1,'2025-06-16 11:59:39','2025-06-16 11:59:39'),(5,2,'Broccoli','Fresh broccoli crowns',1.99,1.00,'products/broccoli.jpg','Green Giant',1.00,'lb','VEG-BROC','100000000005',80,5,0,1,'2025-06-16 11:59:39','2025-06-16 11:59:39'),(6,6,'Whole Milk','Fresh whole milk, vitamin D added',3.49,2.00,'products/milk-whole.jpg','DairyPure',1.00,'gal','DAIRY-MILK-WHOLE','100000000010',60,5,0,1,'2025-06-16 11:59:39','2025-06-16 11:59:39'),(7,6,'2% Reduced Fat Milk','Fresh reduced fat milk',3.29,1.90,'products/milk-2percent.jpg','DairyPure',1.00,'gal','DAIRY-MILK-2PCT','100000000011',55,5,0,1,'2025-06-16 11:59:39','2025-06-16 11:59:39'),(8,16,'White Sandwich Bread','Soft white sandwich bread',2.49,1.25,'products/bread-white.jpg','Wonder',20.00,'oz','BAKERY-BREAD-WHITE','100000000020',40,5,0,1,'2025-06-16 11:59:39','2025-06-16 11:59:39'),(9,16,'Whole Wheat Bread','100% whole wheat bread',2.79,1.40,'products/bread-wheat.jpg','Nature\'s Own',20.00,'oz','BAKERY-BREAD-WHEAT','100000000021',35,5,0,1,'2025-06-16 11:59:39','2025-06-16 11:59:39');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subcategories`
--

DROP TABLE IF EXISTS `subcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subcategories` (
  `subcategory_id` int NOT NULL AUTO_INCREMENT,
  `main_category_id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `image_url` varchar(255) DEFAULT NULL,
  `display_order` int DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`subcategory_id`),
  KEY `main_category_id` (`main_category_id`),
  CONSTRAINT `subcategories_ibfk_1` FOREIGN KEY (`main_category_id`) REFERENCES `main_categories` (`main_category_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subcategories`
--

LOCK TABLES `subcategories` WRITE;
/*!40000 ALTER TABLE `subcategories` DISABLE KEYS */;
INSERT INTO `subcategories` VALUES (1,1,'Fresh Fruits','Seasonal fresh fruits','subcategories/fresh-fruits.jpg',0,1,'2025-06-16 11:59:39'),(2,1,'Fresh Vegetables','Seasonal fresh vegetables','subcategories/fresh-vegetables.jpg',0,1,'2025-06-16 11:59:39'),(3,1,'Organic Produce','Certified organic fruits and vegetables','subcategories/organic.jpg',0,1,'2025-06-16 11:59:39'),(4,1,'Pre-cut & Ready-to-Eat','Washed and prepared produce','subcategories/precut.jpg',0,1,'2025-06-16 11:59:39'),(5,2,'Milk & Cream','Dairy milk and cream products','subcategories/milk.jpg',0,1,'2025-06-16 11:59:39'),(6,2,'Cheese','Various cheese varieties','subcategories/cheese.jpg',0,1,'2025-06-16 11:59:39'),(7,2,'Yogurt','Different yogurt styles and flavors','subcategories/yogurt.jpg',0,1,'2025-06-16 11:59:39'),(8,2,'Eggs','Farm fresh eggs','subcategories/eggs.jpg',0,1,'2025-06-16 11:59:39'),(9,2,'Butter & Margarine','Butter and butter alternatives','subcategories/butter.jpg',0,1,'2025-06-16 11:59:39'),(10,3,'Beef','Fresh beef products','subcategories/beef.jpg',0,1,'2025-06-16 11:59:39'),(11,3,'Poultry','Chicken and turkey products','subcategories/poultry.jpg',0,1,'2025-06-16 11:59:39'),(12,3,'Pork','Fresh pork products','subcategories/pork.jpg',0,1,'2025-06-16 11:59:39'),(13,3,'Seafood','Fish and shellfish','subcategories/seafood.jpg',0,1,'2025-06-16 11:59:39'),(14,3,'Deli Meats','Sliced deli meats','subcategories/deli.jpg',0,1,'2025-06-16 11:59:39'),(15,4,'Bread','Fresh baked breads','subcategories/bread.jpg',0,1,'2025-06-16 11:59:39'),(16,4,'Rolls & Buns','Dinner rolls and burger buns','subcategories/rolls.jpg',0,1,'2025-06-16 11:59:39'),(17,4,'Cakes & Pastries','Desserts and sweet treats','subcategories/pastries.jpg',0,1,'2025-06-16 11:59:39'),(18,4,'Cookies','Fresh baked cookies','subcategories/cookies.jpg',0,1,'2025-06-16 11:59:39'),(19,5,'Water','Bottled and sparkling water','subcategories/water.jpg',0,1,'2025-06-16 11:59:39'),(20,5,'Juice','Fruit and vegetable juices','subcategories/juice.jpg',0,1,'2025-06-16 11:59:39'),(21,5,'Soda','Carbonated soft drinks','subcategories/soda.jpg',0,1,'2025-06-16 11:59:39'),(22,5,'Coffee & Tea','Coffee, tea and accessories','subcategories/coffee.jpg',0,1,'2025-06-16 11:59:39'),(23,5,'Beer & Wine','Alcoholic beverages','subcategories/alcohol.jpg',0,1,'2025-06-16 11:59:39'),(24,6,'Frozen Meals','Prepared frozen meals','subcategories/frozen-meals.jpg',0,1,'2025-06-16 11:59:39'),(25,6,'Ice Cream','Frozen desserts','subcategories/icecream.jpg',0,1,'2025-06-16 11:59:39'),(26,6,'Frozen Vegetables','Frozen vegetable products','subcategories/frozen-veg.jpg',0,1,'2025-06-16 11:59:39'),(27,6,'Frozen Fruits','Frozen fruit products','subcategories/frozen-fruit.jpg',0,1,'2025-06-16 11:59:39'),(28,7,'Pasta & Rice','Dry pasta and rice products','subcategories/pasta.jpg',0,1,'2025-06-16 11:59:39'),(29,7,'Canned Goods','Canned vegetables and fruits','subcategories/canned.jpg',0,1,'2025-06-16 11:59:39'),(30,7,'Baking Supplies','Flour, sugar and baking needs','subcategories/baking.jpg',0,1,'2025-06-16 11:59:39'),(31,7,'Spices & Seasonings','Herbs and spices','subcategories/spices.jpg',0,1,'2025-06-16 11:59:39'),(32,7,'Cooking Oils','Vegetable and specialty oils','subcategories/oils.jpg',0,1,'2025-06-16 11:59:39'),(33,8,'Cleaning Supplies','Home cleaning products','subcategories/cleaning.jpg',0,1,'2025-06-16 11:59:39'),(34,8,'Paper Goods','Paper towels and tissues','subcategories/paper.jpg',0,1,'2025-06-16 11:59:39'),(35,8,'Laundry','Laundry detergents and supplies','subcategories/laundry.jpg',0,1,'2025-06-16 11:59:39'),(36,8,'Trash Bags','Garbage bags and liners','subcategories/trash.jpg',0,1,'2025-06-16 11:59:39');
/*!40000 ALTER TABLE `subcategories` ENABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_category_hierarchy`
--

DROP TABLE IF EXISTS `vw_category_hierarchy`;
/*!50001 DROP VIEW IF EXISTS `vw_category_hierarchy`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_category_hierarchy` AS SELECT 
 1 AS `main_category_id`,
 1 AS `main_category`,
 1 AS `main_category_order`,
 1 AS `subcategory_id`,
 1 AS `subcategory`,
 1 AS `subcategory_order`*/;
SET character_set_client = @saved_cs_client;

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
 1 AS `subcategory`,
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
 1 AS `subcategory_id`,
 1 AS `subcategory_name`,
 1 AS `subcategory_image`,
 1 AS `main_category_id`,
 1 AS `main_category_name`,
 1 AS `main_category_image`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_product_performance`
--

DROP TABLE IF EXISTS `vw_product_performance`;
/*!50001 DROP VIEW IF EXISTS `vw_product_performance`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_product_performance` AS SELECT 
 1 AS `product_id`,
 1 AS `product_name`,
 1 AS `price`,
 1 AS `subcategory`,
 1 AS `main_category`,
 1 AS `times_ordered`,
 1 AS `total_units_sold`,
 1 AS `total_revenue`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_sales_by_category`
--

DROP TABLE IF EXISTS `vw_sales_by_category`;
/*!50001 DROP VIEW IF EXISTS `vw_sales_by_category`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_sales_by_category` AS SELECT 
 1 AS `main_category_id`,
 1 AS `main_category`,
 1 AS `subcategory_id`,
 1 AS `subcategory`,
 1 AS `items_sold`,
 1 AS `total_sales`,
 1 AS `avg_item_price`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_category_hierarchy`
--

/*!50001 DROP VIEW IF EXISTS `vw_category_hierarchy`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_category_hierarchy` AS select `mc`.`main_category_id` AS `main_category_id`,`mc`.`name` AS `main_category`,`mc`.`display_order` AS `main_category_order`,`s`.`subcategory_id` AS `subcategory_id`,`s`.`name` AS `subcategory`,`s`.`display_order` AS `subcategory_order` from (`main_categories` `mc` join `subcategories` `s` on((`mc`.`main_category_id` = `s`.`main_category_id`))) where ((`mc`.`is_active` = true) and (`s`.`is_active` = true)) order by `mc`.`display_order`,`s`.`display_order` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_inventory_status` AS select `p`.`product_id` AS `product_id`,`p`.`name` AS `product_name`,`p`.`quantity_in_stock` AS `quantity_in_stock`,`p`.`min_stock_level` AS `min_stock_level`,(`p`.`quantity_in_stock` < `p`.`min_stock_level`) AS `needs_restocking`,`s`.`name` AS `subcategory`,`mc`.`name` AS `main_category` from ((`products` `p` join `subcategories` `s` on((`p`.`subcategory_id` = `s`.`subcategory_id`))) join `main_categories` `mc` on((`s`.`main_category_id` = `mc`.`main_category_id`))) order by (`p`.`quantity_in_stock` < `p`.`min_stock_level`) desc,`p`.`quantity_in_stock` */;
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
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_product_catalog` AS select `p`.`product_id` AS `product_id`,`p`.`name` AS `product_name`,`p`.`description` AS `description`,`p`.`price` AS `price`,`p`.`quantity_in_stock` AS `quantity_in_stock`,`p`.`image_url` AS `product_image`,`s`.`subcategory_id` AS `subcategory_id`,`s`.`name` AS `subcategory_name`,`s`.`image_url` AS `subcategory_image`,`mc`.`main_category_id` AS `main_category_id`,`mc`.`name` AS `main_category_name`,`mc`.`image_url` AS `main_category_image` from ((`products` `p` join `subcategories` `s` on((`p`.`subcategory_id` = `s`.`subcategory_id`))) join `main_categories` `mc` on((`s`.`main_category_id` = `mc`.`main_category_id`))) where (`p`.`is_active` = true) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_product_performance`
--

/*!50001 DROP VIEW IF EXISTS `vw_product_performance`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_product_performance` AS select `p`.`product_id` AS `product_id`,`p`.`name` AS `product_name`,`p`.`price` AS `price`,`s`.`name` AS `subcategory`,`mc`.`name` AS `main_category`,count(`oi`.`order_item_id`) AS `times_ordered`,sum(`oi`.`quantity`) AS `total_units_sold`,sum(`oi`.`total_price`) AS `total_revenue` from (((`products` `p` left join `order_items` `oi` on((`p`.`product_id` = `oi`.`product_id`))) join `subcategories` `s` on((`p`.`subcategory_id` = `s`.`subcategory_id`))) join `main_categories` `mc` on((`s`.`main_category_id` = `mc`.`main_category_id`))) group by `p`.`product_id`,`p`.`name`,`p`.`price`,`s`.`name`,`mc`.`name` order by `total_revenue` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_sales_by_category`
--

/*!50001 DROP VIEW IF EXISTS `vw_sales_by_category`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_sales_by_category` AS select `mc`.`main_category_id` AS `main_category_id`,`mc`.`name` AS `main_category`,`s`.`subcategory_id` AS `subcategory_id`,`s`.`name` AS `subcategory`,count(`oi`.`order_item_id`) AS `items_sold`,sum(`oi`.`total_price`) AS `total_sales`,avg(`oi`.`unit_price`) AS `avg_item_price` from (((`order_items` `oi` join `products` `p` on((`oi`.`product_id` = `p`.`product_id`))) join `subcategories` `s` on((`p`.`subcategory_id` = `s`.`subcategory_id`))) join `main_categories` `mc` on((`s`.`main_category_id` = `mc`.`main_category_id`))) group by `mc`.`main_category_id`,`mc`.`name`,`s`.`subcategory_id`,`s`.`name` order by `total_sales` desc */;
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

-- Dump completed on 2025-06-17 19:00:14
