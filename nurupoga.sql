-- MariaDB dump 10.19  Distrib 10.11.2-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: nurupoga
-- ------------------------------------------------------
-- Server version	10.11.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `table_comment`
--

DROP TABLE IF EXISTS `table_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table_comment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `content` text NOT NULL,
  `vote` int(11) NOT NULL DEFAULT 0,
  `type` enum('article','question') NOT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `invalid` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_comment`
--

LOCK TABLES `table_comment` WRITE;
/*!40000 ALTER TABLE `table_comment` DISABLE KEYS */;
INSERT INTO `table_comment` VALUES
(1,2,2,'That sounds complicated.\nThe datapack profiles are loaded when the new world screen is created.\nYou would need to find a way to reload them when the user toggles the game difficulty.\nYou can see how fabric modifies this code here:\nhttps://github.com/FabricMC/fabric/blob/1.19.2/fabric-resource-loader-v0/src/client/java/net/fabricmc/fabric/mixin/resource/loader/client/CreateWorldScreenMixin.java\n\nIt also wouldn\'t take into account if the user changes the difficulty in game.\n\nIsn\'t there another direction you could take?\nMaybe doing something with the advancements themselves.\nI don\'t know much about advancements, but I do know you can write and register your own criteria and conditions.\nMaybe this could include a configurable check of the player difficulty?',0,'question','2023-02-14 13:58:05','2023-02-14 13:58:05',0),
(2,2,2,'You probably want `ResourceManagerHelper#registerBuiltinResourcePack`.',0,'question','2023-02-14 14:20:17','2023-02-14 14:20:17',0),
(3,3,2,'thanks, i fixed it, 🤣, it turns out that it\'s `@Mixin(MinecraftServer.class)` and `@Inject(at = @At(\"HEAD\"), method = \"loadWorld\")`',0,'question','2023-02-15 15:18:07','2023-02-15 15:18:07',0),
(4,5,1,'Yep, `modifyPools` is the correct one. You pass it a lambda where you can modify the loot pools via builders as if you were creating new ones.\n\nSee the testmod code: \n```\ntableBuilder.modifyPools(poolBuilder -> poolBuilder.with(ItemEntry.builder(Items.EMERALD)));\n```',0,'question','2023-02-15 15:56:17','2023-02-15 15:56:17',0),
(5,7,2,'The cloud particle effect hardwires its `Particle.collidesWithWorld` to false in its constructor.\nBut even then, I believe setting it to true just checks block collisions and the world border, not entity collision.\n\nTo get entity collisions you are going to have to write your own Particle (e.g. copy `CloudParticle`) then override the `Particle.move()` method to also check entity collision.\nAgain, you have to do this yourself, normaly entity collision requires an entity to check against other entities, e.g. see `ProjectileUtil.getEntityCollision`.',0,'question','2023-02-15 19:51:52','2023-02-15 19:51:52',0),
(6,19,1,'it appears your github link does not contain your most recent changes (not commited and pushed)\n\nIntrusive holders are objects that when constructed are required to be registered. This includes Items and Blocks (and entities and a few others).\n\nMake sure you are registering your items and blocks and if its in another class, be sure to reference that class during your initialization to ensure it runs its class init code.',0,'question','2023-02-17 13:06:35','2023-02-17 13:06:35',0),
(7,20,9,'You can change the floats to doubles and also use the built-in Math class.\n\nI think that double can store more decimals than float, since double stores 64 bits of information whereas float stores 32 bits of information.\n\nhttps://docs.oracle.com/javase/tutorial/java/nutsandbolts/datatypes.html\n\nIt is also the case that the static method Math.sqrt(n) returns a double, so it makes sense to use double.\n\nHere is a code example.\n```\npublic class BinetsFormula {\n  \n    public int fib(int n) {\n        double a = (1 + Math.sqrt(5))/2;\n        double b = (1 - Math.sqrt(5))/2;\n        double c = (Math.pow(a, n) - Math.pow(b, n))/Math.sqrt(5);\n        return (int) c;\n    }\n\n    public static void main(String[] args) {\n        BinetsFormula formula = new BinetsFormula();\n        for (int i = 0; i < 20; i++) {\n            if (i < 19)\n                System.out.print(formula.fib(i) + \" \");\n            else if (i == 19) \n                System.out.println(formula.fib(i));\n        }\n    }\n}\n```\n\nThe above code prints out the first 20 fibonacci numbers.\n\nNow we can get the sum of all even fibonacci numbers less than 4,000,000.\n\n```\npublic class BinetsFormula {\n \n    private final double sqrt5 = Math.sqrt(5);\n    private final double a = (1 + sqrt5)/2;\n    private final double b = (1 - sqrt5)/2;\n\n    public long fib(int n) {\n        return Math.round((Math.pow(a, n) - Math.pow(b, n))/sqrt5);\n    }\n\n    public static void main(String[] args) {\n        BinetsFormula formula = new BinetsFormula();\n        int n = 0;\n        long f = 0;\n        long sum = 0;\n        long max = 4000000;\n        while ((f = formula.fib(n)) < max) {\n            if (f % 2 == 0)\n                sum += f;\n            n++;\n        }\n        System.out.printf(\"Sum: %d\\n\", sum);\n    }\n}\n```\nThe second example is optimized.\n\nI created the constants sqrt5, a, and b so that these computations are only performed once.',0,'question','2023-02-22 11:21:56','2023-02-22 11:21:56',0),
(8,21,9,'The docs have a whole section about what to avoid in the classloading: https://github.com/Chocohead/Fabric-ASM/blob/master/README.md#navigating-the-entrance\nBasically, your shouldn\'t be loading any minecraft classes either directly, or via any of your own classes that reference/load minecraft classes. The processing occurs too early to start loading minecraft.\n\nThe example I linked on your previous question, shows one way to reference (but not load) a minecraft class for the constructor parameters. In that example it is the ItemStack class\nhttps://github.com/Chocohead/Fabric-ASM/blob/master/example/src/com/chocohead/mm/testing/EarlyRiser.java#L22-L29',0,'question','2023-03-06 08:54:36','2023-03-06 08:54:36',0),
(9,8,2,'1.19.3',0,'article','2023-03-15 14:03:37','2023-03-15 14:03:37',0);
/*!40000 ALTER TABLE `table_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_gitee`
--

DROP TABLE IF EXISTS `table_gitee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table_gitee` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `gitee_id` int(11) NOT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `invalid` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_gitee`
--

LOCK TABLES `table_gitee` WRITE;
/*!40000 ALTER TABLE `table_gitee` DISABLE KEYS */;
INSERT INTO `table_gitee` VALUES
(1,9,1719034,'2023-02-21 11:43:17','2023-02-21 11:43:17',0);
/*!40000 ALTER TABLE `table_gitee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_notice`
--

DROP TABLE IF EXISTS `table_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table_notice` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `type` enum('publish_comment','publish_post','answer_has_been_accepted') NOT NULL,
  `self` bigint(20) NOT NULL,
  `at` bigint(20) NOT NULL,
  `at_user` bigint(20) NOT NULL,
  `create_time` datetime NOT NULL,
  `unread` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_notice`
--

LOCK TABLES `table_notice` WRITE;
/*!40000 ALTER TABLE `table_notice` DISABLE KEYS */;
INSERT INTO `table_notice` VALUES
(1,2,'publish_post',2,2,2,'2023-02-13 13:02:26',1),
(2,2,'publish_post',3,3,2,'2023-02-13 13:04:39',1),
(3,2,'publish_post',5,5,2,'2023-02-13 13:12:24',1),
(4,2,'publish_post',6,6,2,'2023-02-13 13:17:12',1),
(5,2,'publish_post',7,7,2,'2023-02-15 19:16:01',1),
(6,1,'publish_post',8,8,1,'2023-02-15 20:13:02',1),
(7,1,'publish_post',9,9,1,'2023-02-15 20:19:44',1),
(8,1,'publish_post',10,10,1,'2023-02-15 20:22:16',1),
(9,1,'publish_post',11,11,1,'2023-02-15 20:23:24',1),
(10,1,'publish_post',12,12,1,'2023-02-15 20:34:30',1),
(11,1,'publish_post',13,13,1,'2023-02-15 20:35:20',1),
(12,1,'publish_post',14,14,1,'2023-02-15 20:35:57',1),
(13,1,'publish_post',15,15,1,'2023-02-15 20:36:37',1),
(14,1,'publish_post',16,16,1,'2023-02-15 20:40:54',1),
(15,1,'publish_post',17,17,1,'2023-02-15 20:41:26',1),
(16,1,'publish_post',18,18,1,'2023-02-15 20:50:12',1),
(17,1,'publish_post',19,19,1,'2023-02-17 13:06:18',1),
(18,9,'publish_post',20,20,9,'2023-02-22 11:08:02',1),
(19,1,'publish_post',21,21,1,'2023-03-06 08:42:03',1),
(20,2,'publish_comment',1,2,2,'2023-02-14 13:58:05',1),
(21,2,'publish_comment',2,2,2,'2023-02-14 14:20:17',1),
(22,2,'publish_comment',3,3,2,'2023-02-15 15:18:07',1),
(23,1,'publish_comment',4,5,2,'2023-02-15 15:56:17',1),
(24,2,'publish_comment',5,7,2,'2023-02-15 19:51:52',1),
(25,1,'publish_comment',6,19,1,'2023-02-17 13:06:35',1),
(26,9,'publish_comment',7,20,9,'2023-02-22 11:21:56',1),
(27,9,'publish_comment',8,21,1,'2023-03-06 08:54:36',1),
(28,2,'publish_comment',9,8,1,'2023-03-15 14:03:37',1),
(29,2,'answer_has_been_accepted',1,2,2,'2023-02-15 12:25:47',1),
(30,2,'answer_has_been_accepted',2,4,1,'2023-02-15 16:16:13',1),
(31,2,'answer_has_been_accepted',3,5,2,'2023-02-15 19:52:01',1),
(32,1,'answer_has_been_accepted',4,6,1,'2023-02-17 13:06:56',1),
(33,9,'answer_has_been_accepted',5,7,9,'2023-02-22 11:23:32',1),
(34,1,'answer_has_been_accepted',6,8,9,'2023-03-06 08:55:38',1);
/*!40000 ALTER TABLE `table_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_permission`
--

DROP TABLE IF EXISTS `table_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(16) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_permission`
--

LOCK TABLES `table_permission` WRITE;
/*!40000 ALTER TABLE `table_permission` DISABLE KEYS */;
INSERT INTO `table_permission` VALUES
(1,'publish_post'),
(2,'publish_comment'),
(3,'delete_post'),
(4,'delete_comment'),
(5,'create_user'),
(6,'delete_user'),
(7,'ban_user');
/*!40000 ALTER TABLE `table_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_post`
--

DROP TABLE IF EXISTS `table_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table_post` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `vote` int(11) NOT NULL DEFAULT 0,
  `reply` int(11) NOT NULL DEFAULT 0,
  `view` int(11) NOT NULL DEFAULT 0,
  `type` enum('article','question') NOT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `invalid` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_post`
--

LOCK TABLES `table_post` WRITE;
/*!40000 ALTER TABLE `table_post` DISABLE KEYS */;
INSERT INTO `table_post` VALUES
(2,2,'Split \"Fabric Mods\" datapack','I have 2 datapacks with achievements, in which the first datapack is the base, and the second overrides some of the achievements from the base (required for hardcore). How do I add both of these datapacks to the data folder so that the \"Fabric mods\" datapack is split into two datapacks that I can further manage from the code? The datapack for hardcore should automatically turn on and off before world creation, depending on whether the player has selected hardcore mode or not. (this is roughly how I imagine it to be a mixin)\n```\n@Mixin(CreateWorldScreen.class)\npublic class CreateWorldScreenMixin {\n\n    @Shadow\n    public boolean hardcore;\n\n    @Shadow\n    protected DataPackSettings dataPackSettings;\n\n    @Inject(method = \"createLevel\", at = @At(\"HEAD\"))\n    public void createLevelInject(CallbackInfo ci) {\n        // hardcore datapack is disabled by default\n        if (hardcore) {\n            List<String> enabled = new ArrayList<>(dataPackSettings.getEnabled());\n            enabled.add(\"datapack_for_hardcore\");\n            dataPackSettings = new DataPackSettings(enabled, new ArrayList<>());\n        }\n    }\n}\n```',18,2,67,'question','2023-02-13 13:02:26','2023-03-15 14:03:48',0),
(3,2,'What is the load world mixin called?','I want to create a mixin that creates a timer when a world loads. However, I don\'t see anything like\n\n`LoadWorld.class`\n\nCould you please suggest what it\'s called?',0,1,7,'question','2023-02-13 13:04:39','2023-03-15 14:03:48',0),
(5,2,'Modifying Vanilla Loot Tables but only enabling one item or the other to drop','Dear Fabric Team or any other helpful developers, I\'m fairly new to modding and have been attempting to have a modded item I created to have same behavior as flint from gravel except its from obsidian, I\'ve gotten it to have the chance to drop but the original loot table drop still drops also, I\'ve gathered it has something to do with the\nFabricLootTableBuilder.modifyPools(java.util.function.Consumer) function but have no idea how to go about implementing it into my code and can\'t find any documentation about it anywhere',0,1,40,'question','2023-02-13 13:12:24','2023-03-15 14:03:48',0),
(6,2,'amadeus api : offer pricing call produces 400 - type needed','I\'m calling the offer price API and receiving a 400 with a \"type needed\" message.\n> org.springframework.web.util.NestedServletException: Request processing failed; nested exception is com.amadeus.exceptions.ClientException: [400] type needed\n\nThe call via postman API succeeds (https://test.api.amadeus.com/v1/shopping/flight-offers/pricing), so I take the body used in that, and send it via java API call where I receive the error.\n\nThis is on test env.\n\nhttps://test.api.amadeus.com/v1/shopping/flight-offers/pricing\n\nThe body sent (which is taken from the working postman example):\n```\n{\n  \"type\": \"flight-offer\",\n  \"id\": \"1\",\n  \"source\": \"GDS\",\n  \"instantTicketingRequired\": false,\n  \"nonHomogeneous\": false,\n  \"oneWay\": false,\n  \"lastTicketingDate\": \"2022-11-01\",\n  \"numberOfBookableSeats\": 9,\n  \"itineraries\": [\n    {\n      \"duration\": \"PT1H20M\",\n      \"segments\": [\n        {\n          \"departure\": {\n            \"iataCode\": \"LHR\",\n            \"terminal\": \"4\",\n            \"at\": \"2022-11-01T06:25:00\"\n          },\n          \"arrival\": {\n            \"iataCode\": \"CDG\",\n            \"terminal\": \"2E\",\n            \"at\": \"2022-11-01T08:45:00\"\n          },\n          \"carrierCode\": \"AF\",\n          \"number\": \"1381\",\n          \"aircraft\": {\n            \"code\": \"320\"\n          },\n          \"operating\": {\n            \"carrierCode\": \"AF\"\n          },\n          \"duration\": \"PT1H20M\",\n          \"id\": \"1\",\n          \"numberOfStops\": 0,\n          \"blacklistedInEU\": false\n        }\n      ]\n    },\n    {\n      \"duration\": \"PT1H20M\",\n      \"segments\": [\n        {\n          \"departure\": {\n            \"iataCode\": \"CDG\",\n            \"terminal\": \"2E\",\n            \"at\": \"2022-11-05T18:00:00\"\n          },\n          \"arrival\": {\n            \"iataCode\": \"LHR\",\n            \"terminal\": \"4\",\n            \"at\": \"2022-11-05T18:20:00\"\n          },\n          \"carrierCode\": \"AF\",\n          \"number\": \"1180\",\n          \"aircraft\": {\n            \"code\": \"319\"\n          },\n          \"operating\": {\n            \"carrierCode\": \"AF\"\n          },\n          \"duration\": \"PT1H20M\",\n          \"id\": \"6\",\n          \"numberOfStops\": 0,\n          \"blacklistedInEU\": false\n        }\n      ]\n    }\n  ],\n  \"price\": {\n    \"currency\": \"EUR\",\n    \"total\": \"255.30\",\n    \"base\": \"48.00\",\n    \"fees\": [\n      {\n        \"amount\": \"0.00\",\n        \"type\": \"SUPPLIER\"\n      },\n      {\n        \"amount\": \"0.00\",\n        \"type\": \"TICKETING\"\n      }\n    ],\n    \"grandTotal\": \"255.30\",\n    \"additionalServices\": [\n      {\n        \"amount\": \"50.00\",\n        \"type\": \"CHECKED_BAGS\"\n      }\n    ]\n  },\n  \"pricingOptions\": {\n    \"fareType\": [\n      \"PUBLISHED\"\n    ],\n    \"includedCheckedBagsOnly\": false\n  },\n  \"validatingAirlineCodes\": [\n    \"AF\"\n  ],\n  \"travelerPricings\": [\n    {\n      \"travelerId\": \"1\",\n      \"fareOption\": \"STANDARD\",\n      \"travelerType\": \"ADULT\",\n      \"price\": {\n        \"currency\": \"EUR\",\n        \"total\": \"127.65\",\n        \"base\": \"24.00\"\n      },\n      \"fareDetailsBySegment\": [\n        {\n          \"segmentId\": \"1\",\n          \"cabin\": \"ECONOMY\",\n          \"fareBasis\": \"GS50OALG\",\n          \"brandedFare\": \"LIGHT2\",\n          \"class\": \"G\",\n          \"includedCheckedBags\": {\n            \"quantity\": 0\n          }\n        },\n        {\n          \"segmentId\": \"6\",\n          \"cabin\": \"ECONOMY\",\n          \"fareBasis\": \"GS50OALG\",\n          \"brandedFare\": \"LIGHT2\",\n          \"class\": \"G\",\n          \"includedCheckedBags\": {\n            \"quantity\": 0\n          }\n        }\n      ]\n    },\n    {\n      \"travelerId\": \"2\",\n      \"fareOption\": \"STANDARD\",\n      \"travelerType\": \"ADULT\",\n      \"price\": {\n        \"currency\": \"EUR\",\n        \"total\": \"127.65\",\n        \"base\": \"24.00\"\n      },\n      \"fareDetailsBySegment\": [\n        {\n          \"segmentId\": \"1\",\n          \"cabin\": \"ECONOMY\",\n          \"fareBasis\": \"GS50OALG\",\n          \"brandedFare\": \"LIGHT2\",\n          \"class\": \"G\",\n          \"includedCheckedBags\": {\n            \"quantity\": 0\n          }\n        },\n        {\n          \"segmentId\": \"6\",\n          \"cabin\": \"ECONOMY\",\n          \"fareBasis\": \"GS50OALG\",\n          \"brandedFare\": \"LIGHT2\",\n          \"class\": \"G\",\n          \"includedCheckedBags\": {\n            \"quantity\": 0\n          }\n        }\n      ]\n    }\n  ]\n}\n```\n\nJava API call I make couldn\'t be simpler:\n```\n        <!-- https://mvnrepository.com/artifact/com.google.code.gson/gson -->\n        <dependency>\n            <groupId>com.google.code.gson</groupId>\n            <artifactId>gson</artifactId>\n            <version>2.9.0</version>\n        </dependency>\n\n        <!-- https://mvnrepository.com/artifact/com.amadeus/amadeus-java -->\n        <dependency>\n            <groupId>com.amadeus</groupId>\n            <artifactId>amadeus-java</artifactId>\n            <version>6.2.0</version>\n        </dependency>\n```\n```\n    @PostMapping(\"/confirm\")\n    public ResponseEntity<FlightPrice> confirm(@RequestBody FlightOfferSearch search) throws ResponseException {\n        return ResponseEntity.ok(amadeusConnector.confirm(search));\n    }\n```\n```\n    public FlightPrice confirm(FlightOfferSearch offer) throws ResponseException {\n        return amadeus.shopping.flightOffersSearch.pricing.post(offer);\n    }\n```',0,0,47,'question','2023-02-13 13:17:12','2023-03-15 14:03:48',0),
(7,2,'How to draw particles from BlockPos A to BlockPos B','Hello! I want to make an item that draws particles to nearby, living entities every inventory tick. This is the code that I have tried:\n```\npublic class OreFinderItem extends Item {\n\n    public OreFinderItem(Settings settings) {\n        super(settings);\n    }\n\n    @Override\n    public void inventoryTick(ItemStack stack, World world, Entity entity, int slot, boolean selected) {\n        if (stack.getItem() == ModItems.ORE_FINDER && entity instanceof PlayerEntity)\n        {\n            drawParticles(world, (PlayerEntity) entity);\n        }\n\n        super.inventoryTick(stack, world, entity, slot, selected);\n    }\n\n    public void drawParticles(World world, PlayerEntity user) {\n        if (world.isClient)\n        {\n            BlockPos playerPos = user.getBlockPos();\n            int x = playerPos.getX();\n            int y = playerPos.getY();\n            int z = playerPos.getZ();\n\n            List<LivingEntity> livingEntities = world.getEntitiesByClass(LivingEntity.class,\n                    new Box(x - 10, y - 10, z - 10, x + 10, y + 10, z + 10),\n                    EntityPredicates.VALID_ENTITY);\n\n            for (LivingEntity entity : livingEntities)\n            {\n                if (entity != user)\n                {\n                    Vec3d entityVector = new Vec3d(entity.getX(), entity.getY(), entity.getZ());\n                    Vec3d playerVector = new Vec3d(x, y, z);\n\n                    Vec3d velocity = entityVector.subtract(playerVector);\n\n                    world.addParticle(ParticleTypes.CLOUD,\n                            x, y, z,\n                            velocity.x, velocity.y, velocity.z);\n                }\n            }\n        }\n    }\n}\n```\ndrawParticles() is called as expected, and does draw particles from the player to the entity. The problem is that the particles go directly through the entity, and go past it indefinitely...\nHow can I get it so that it stops at the entity\'s position, in other words, point B?',5,1,86,'question','2023-02-15 19:16:01','2023-03-15 14:03:57',0),
(8,1,'Fabric for Minecraft 1.19.3','Minecraft 1.19.3 is almost here, with big changes to game internals. Beginning with this update, [Mojang have changed their versioning scheme](https://help.minecraft.net/hc/en-us/articles/9971900758413) such that \'minor\' releases like this one may contain larger changes under the hood. As such, the changes in this version affect almost all mods (not even comparable to the changes in 1.18.2, and significantly bigger than 1.19). Here are the list of all major modder-facing changes in this version.\n\nAs usual, we ask players to be patient, and give mod developers time to update to this new version.\n\n## Fabric changes\nDevelopers should use Loom 1.0 (at the time of writing) to develop for Minecraft 1.19.3.\n\nMinecraft 1.19.3 introduces numerous breaking changes to major developer-facing APIs.\n\n### Fabric API Mod ID change\nThe mod ID of Fabric API is now `fabric-api`. The old ID `fabric` still works in `fabric.mod.json`, such as `depends`; however, the new ID is recommended for better user experience when Fabric API is missing.\n\n### New Fabric API features\nFabric API added many features since the last update blog post:\n\n- Item API: support stack-aware recipe remainders. (AlphaMode)\n- Content Registries: register villager interactions, sculk sensor frequencies, and path node types (aws404, Shnupbups, devpelux)\n- Client Tags: allow client-side mods to rely on tags not present on the server. (dexman545)\n- Entity Events: add `AFTER_DEATH`, `AFTER_DAMAGE`, and `ALLOW_DEATH` events. (Technici4n)\n- Resource Conditions: support all tags. (apple502j)\n- Sound API: play custom sounds. (SquidDev)\n- Resource Loader: support `Text` as pack display name. (apple502j)\n- Block Appearance API: groundwork for cross-mod connected textures. (Technici4n)\n- `FabricLanguageProvider`: easily generate language JSON files with data generation. (mineblock11)\n- Overwriting Screen Handler Factory: open new screen handlers without re-centering the mouse pointer. (apple502j)\n- Transfer API: add several helper APIs for fluid interactions and storage. (Technici4n)\n\n## Minecraft changes\n\n### Registries\n\nThere are several changes to registries.\n\nThe most impactful change is that **the `Registry` class is now split into 3 different classes**:\n\n- `RegistryKeys` holds the `RegistryKey` instances used for registries, previously held in `Registry`\'s `static final` fields.\n- `Registries` holds all static registry instances.\n- `Registry` is now an interface and holds everything else.\n\nTogether with this change, the `KEY` suffixes for registry key fields have been removed.\n\n```diff\n- Registry.register(Registry.BLOCK_KEY, new Identifier(\"test\", \"dirt\"), DIRT_BLOCK);\n+ Registry.register(Registries.BLOCK, new Identifier(\"test\", \"dirt\"), DIRT_BLOCK);\n```\n\nIn many parts of the code, `Registry`  is now replaced with `RegistryEntryLookup` or `Registerable`. `RegistryEntryLookup` is a read-only view of a registry, while `Registerable` is a write-only view. The `BuiltinRegistries` class no longer holds the built-in registry; it instead holds the builder to create a `RegistryEntryLookup.RegistryLookup` (a lookup of registry lookups, similar to `DynamicRegistryManager`). See below for migrating old worldgen code.\n\nSince virtually all registry-related code needs a rewrite, Yarn used this opportunity to **repackage the registry and tag packages** under `net.minecraft.registry` and `net.minecraft.registry.tag` respectively. Note, if you are using Mojang Mappings or other third-party mappings, this does not affect you. A simple find-and-replace should be enough:\n\n```diff\n- import net.minecraft.tag.TagKey;\n- import net.minecraft.util.registry.Registry;\n- import net.minecraft.util.registry.RegistryEntry;\n+ import net.minecraft.registry.tag.TagKey;\n+ import net.minecraft.registry.Registry;\n+ import net.minecraft.registry.entry.RegistryEntry;\n```\n\nFabric API\'s `DynamicRegistrySetupCallback` was changed to take a new context object `DynamicRegistryView` instead of a `DynamicRegistryManager`. This API allows easy registration of events, while preventing crashes caused by the misuse of previous API.\n\n### Item Groups\nOne of the major changes in this version involve the Creative inventory screen. Items can now appear in multiple tabs and the display order no longer relies on the item registration order. Item groups got a significant refactor during this process.\n\nThe `fabric-item-groups-v0` module is replaced with `fabric-item-group-api-v1`. This is now required for adding items to vanilla item groups; you can no longer specify the item group using `Item.Settings`.\n\nTo add an item to a vanilla or other existing item group, use `ItemGroupEvents`.\n\n```java\n// 1.19.2\nItem MY_ITEM = new Item(new Item.Settings().group(ItemGroup.MISC));\n// 1.19.3\nItemGroupEvents.modifyEntriesEvent(ItemGroups.INGREDIENTS).register(entries -> entries.add(MY_ITEM));\n// Instead of ItemGroup, you can also specify an Identifier for modded item groups.\n```\n\nTo create a new item group, use `FabricItemGroup.builder()`. This allows adding items directly, without using `ItemGroupEvents`:\n\n```java\nItemGroup ITEM_GROUP = FabricItemGroup.builder(new Identifier(\"example\", \"test_group\"))\n    .displayName(Text.literal(\"Example Item Group\"))\n    .icon(() -> new ItemStack(Items.DIAMOND))\n    .entries((enabledFeatures, entries, operatorEnabled) -> {\n        entries.add(Items.DIAMOND);\n    })\n    .build();\n```\n\nThe changes also made it possible to add items at a specific position in the Creative inventory. Check the [FabricItemGroupEntries javadoc](https://maven.fabricmc.net/docs/fabric-api-0.68.1+1.19.3/net/fabricmc/fabric/api/itemgroup/v1/FabricItemGroupEntries.html) for details.\n\n<!-- TODO update link after the FAPI release -->\n\n### Data generation\nA number of breaking changes have been made to the Data Generation API.\n\nData generators now have to create a \"pack\" and add providers to the pack. (It\'s like a resource pack - the provider generates a resource for a specific pack.) This can be done with `FabricDataGenerator#createPack`, or `createBuiltinResourcePack` for packs loadable by `ResouceManagerHelper#registerBuiltinResourcePack`.\n\n```java\nFabricDataGenerator.Pack pack = dataGenerator.createPack();\npack.addProvider(YourProvider::new);\n```\nData generator constructors now take `FabricDataOutput` as an argument instead of `DataGenerator`. `generateStuff` methods (e.g. `generateBlockLootTables`) are now provided from the vanilla game and renamed to `generate`. They are also now public, not protected.\n```java\npublic class TestBlockLootTableProvider extends FabricBlockLootTableProvider {\n    public TestBlockLootTableProvider(FabricDataGenerator dataGenerator) {\n        super(dataGenerator);\n    }\n    @Override\n    // Renamed from generateBlockLootTables and now public\n    public void generate() {\n        addDrop(SIMPLE_BLOCK);\n    }\n}\n```\nFor tag generators, the constructor must also take `CompletableFuture<RegistryWrapper.WrapperLookup>`. `FabricTagProvider.DynamicRegistryTagProvider` is now replaced with just `FabricTagProvider`. The `configure` method is used to add tags.\n```java\npublic class TestBiomeTagProvider extends FabricTagProvider<Biome> {\n    public TestBiomeTagProvider(FabricDataOutput output, CompletableFuture<RegistryWrapper.WrapperLookup> registriesFuture) {\n        super(output, RegistryKeys.BIOME, registriesFuture);\n    }\n    @Override\n    protected void configure(RegistryWrapper.WrapperLookup registries) {\n        getOrCreateTagBuilder(TagKey.of(RegistryKeys.BIOME, new Identifier(MOD_ID, \"example\")))\n        .add(BiomeKeys.BADLANDS);\n    }\n}\n```\n### Custom world generation\nIn the registry section we briefly mentioned that `BuiltinRegistries` no longer holds the actual registries; more specifically, `BuiltinRegistries` is no longer used during actual world generation. If your biome mod, structure mod, 1.19 message type mod etc. registers stuff into `BuiltinRegistries`, you now need to generate its JSON and include it in the mod as a data pack.\nYou can override the new `DataGeneratorEntrypoint.buildRegistry(RegistryBuilder registryBuilder)` in your data gen entrypoint to add your modded entries the registry used for datageneration. `buildRegistry` is invoked asynchronously and the resulting `RegistryWrapper.WrapperLookup` can be passed to your data providers using a `CompletableFuture`.\n```java\npublic class DataGeneratorEntrypoint implements net.fabricmc.fabric.api.datagen.v1.DataGeneratorEntrypoint {\n	// onInitializeDataGenerator goes here\n	@Override\n	public void buildRegistry(RegistryBuilder registryBuilder) {\n            registryBuilder.addRegistry(RegistryKeys.BIOME, ExampleBiomes::bootstrap);\n	}\n}\n// Minecraft\'s BuiltinBiomes class is another good example.\npublic final class ExampleBiomes {\n    public static final RegistryKey<Biome> MODDED_BIOME_KEY = RegistryKey.of(RegistryKeys.BIOME, new Identifier(\"modid\", \"biome_name\"));\n    public static void bootstrap(Registerable<Biome> biomeRegisterable) {\n        biomeRegisterable.register(MODDED_BIOME_KEY, createBiome());\n    }\n}\n```\nA new data generator, `FabricDynamicRegistryGenerator`, allows generating the JSON files from the previously-registered objects.\n```java\npublic class WorldgenProvider extends FabricDynamicRegistryProvider {\n    public WorldgenProvider(FabricDataOutput output, CompletableFuture<RegistryWrapper.WrapperLookup> registriesFuture) {\n        super(output, registriesFuture);\n    }\n    @Override\n    protected void configure(RegistryWrapper.WrapperLookup registries, Entries entries) {\n        final RegistryWrapper.Impl<Biome> biomeRegistry = registries.getWrapperOrThrow(RegistryKeys.BIOME);\n        entries.add(ExampleBiomes.MODDED_BIOME_KEY, biomeRegistry.getOrThrow(ExampleBiomes.MODDED_BIOME_KEY).value());\n    }\n}\n```\n### Textures\nThe performance optimizations in 1.19.3 include texture loading changes. By default, textures used in a certain atlas (such as block texture atlas) must now be in the folder for the type of the atlas (such as `textures/block`). This affects some resource packs, which might be bundled in a mod.\nTo use custom textures located elsewhere, an atlas configuration file should be added to the resource pack. See the [22w46a update blogpost](https://www.minecraft.net/en-us/article/minecraft-snapshot-22w46a) for more details.\nFabric Textures API is removed entirely; `ClientSpriteRegistryCallback` is replaced with atlas configuration files, and `DependentSprite` was practically unused.\n### Resource loading\nThere are many refactors to resource loading, such as using a custom filesystem to improve performance. However they should not affect most mods.\nOne change made in the refactor is that resource packs now allow `Text` to be used as the display name. With this change,`ResourceManagerHelper#registerBuiltinResourcePack` method can now take `Text`. The old `String` based method is now deprecated; use `Text#literal` for a hard-coded name.\nMods that support additional resource types should now use `ResourceFinder`. This, when given a resource manager, returns the map of IDs to `Resource`s.\n```java\npublic static final ResourceFinder JSON_FINDER = ResourceFinder.json(\"tiny_potatoes\");\npublic static final ResourceFinder PNG_FINDER = new ResourceFinder(\"tiny_potatoes\", \".png\");\n// to use:\nJSON_FINDER.findResources(resourceManager).forEach((id, resource) -> {});\n```\n### Command changes\nSeveral command argument types are removed and consolidated. They include: `EnchantmentArgumentType`, `EntitySummonArgumentType`, and `StatusEffectArgumentType`. There are 2 new argument types that replace those.\n- `RegistryEntryArgumentType`, which is an argument type of `RegistryEntry<T>`\n- `RegistryEntryPredicateArgumentType`, which works like `RegistryPredicateArgumentType` but the entry is either named `RegistryEntryList` (tags) or `RegistryEntry` (one entry)\n### Move to JOML\nMojang has started using the JOML library for rendering-related math. `Vec3f` is now replaced with JOML `Vector3f`. Many of the functions have slightly different names. For example:\n```diff\n- import net.minecraft.util.math.Vec3f;\n+ import org.joml.Vector3f;\n- Vector3f vec;\n- float x = vec.getX();\n+ Vec3f vec;\n+ float x = vec.x();\n```\n`Vec3d` and `Vec3i` are unaffected.\n### Sounds\nDuring the pre-release phase of 1.19.3, there were changes to how sounds are referenced and played.\n- Introduction: there are two ways a sound is referred to - \"sound asset\" defined by the client and identified by sound ID, and \"sound event\" used by the server and registered in a registry.\n- Previously, to play a registered sound event, `PlaySoundS2CPacket` was used, and to play a custom (resource pack-defined) sound, `PlaySoundIdS2CPacket` was used.\n- References to `SoundEvent` are mostly replaced with `Registry<SoundEvent>`.\n- `SoundEvent` should now be constructed using `SoundEvent.of`, which is transitively access-widened by Fabric API.\n- `PlaySoundIdS2CPacket` was removed. To play a custom sound, use direct registry entry (`RegistryEntry.of(SoundEvent)`).\n- Biome Modification API received a breaking change to accept `RegistryEntry<SoundEvent>` instead of `SoundEvent`.\n### Other changes\nHere are other miscellaneous changes in 1.19.3:\n- Feature flags were introduced. Currently, blocks, items, and entity types can be hidden behind a flag. \"Experimental\" features that aren\'t enabled by a feature flag are still registered in a registry, but are ignored in most methods. Resource Condition API can now check feature flags.\n- For those who use the vanilla system for GUIs (instead of third-party APIs): a new grid-based GUI system is added. This can be used in place of the old way of positioning widgets, and reduces the need for hard-coded display positions.\n- `ButtonWidget` is now constructed using a builder.\n- Tooltips got a refactor to support item group related changes. `Screen#setTooltip` methods are added; there are three overloads. They all have to be called at every render call. `setTooltip` method is also available for `ClickableWidget` and `ButtonWidget.Builder`.\n- Networking changes: chat preview was removed, and the game no longer requires a header packet to be sent when blocking messages. The client-side `sendChatMessage` and `sendCommand` methods have been moved from `ClientPlayerEntity` to `ClientPlayNetworkHandler`.\n- Mobs using `Brain` for control can now take advantage of functional `Task` creation. This resembles React Hooks and is replacing the previous subclass-based approach in vanilla. See [javadoc](https://maven.fabricmc.net/docs/yarn-1.19.3-rc1+build.2/net/minecraft/entity/ai/brain/task/TaskTriggerer.html) for examples. <!-- TODO replace link -->\n- `ItemStack#isItemEqualIgnoreDamage` and `ItemStack#areItemsEqualIgnoreDamage` were removed. Either use standard `isItemEqual`/`areItemsEqual` or compare yourself.\n- `JsonHelper#deserialize` no longer permits `null`. Use `deserializeNullable` instead.\n### Yarn renames\n*If you are using Mojang Mappings or other third-party mappings, you can skip this section.*\nThere are dozens of renames to fix wrong names and improve code readability. Here are some of the major renames:\n- `createAndScheduleBlockTick`/``createAndScheduleFluidTick`` is now simply`scheduleBlockTick`/`scheduleFluidTick`.\n- `OreBlock` is renamed to `ExperienceDroppingBlock` as it is used by a Sculk block.\n- `WallStandingBlockItem` is renamed to `VerticallyAttachableBlockItem` because it can now be used for hanging blocks as well.\n- `AbstractButtonBlock` is renamed to ButtonBlock as it is no longer `abstract`\n- `ScreenHandler#transferSlot` is renamed to `quickMove` to be more descriptive.\n- Shaders and programs were renamed. A program is composed of vertex and fragment shaders; this was previously swapped. See [the pull request](https://github.com/FabricMC/yarn/pull/3384) for details.',0,1,10,'article','2023-02-15 20:13:02','2023-03-15 14:04:24',0),
(9,1,'Fabric for Minecraft 1.19','Minecraft 1.19: *The Wild Update* is now released, and along with it, updates for Fabric itself and many mods already.\n\n\n## For Players\n\nPlayers should use Fabric Installer 0.11.0 and Fabric Loader 0.14.6 (at the time of writing) to play on Minecraft 1.19.\n\nPlenty of mods have already updated to 1.19 already, and we expect many more to be on the way. Please be patient as mod developers dedicate some of their free time to updating their mods to this new version.\n\n## Fabric Changes For Mod Developers\n\nDevelopers should use Loom 0.12 (at the time of writing) to develop for Minecraft 1.19.\n\nMinecraft 1.19 introduces several code changes to major developer-facing APIs. In addition, Fabric has introduced several new ways for mod developers to safely develop server-side mods without accidentally relying on client-exclusive code.\n\n### New Fabric API features\nFabric API added many features since the last update blog post:\n- Data Generation: easily generate JSON files for blocks, recipes, advancements, etc... (modmuss50)\n- Entity API Lookup: flexible retrieval of object instances from entities. (deirn)\n- Resource Conditions: only enable select recipes, advancements, etc... when specific conditions are met. (Technici4n)\n- Transitive Access Widener module: directly use many private/protected classes and methods in vanilla. (Juuxel)\n- FluidVariant Attributes: define and access name, temperature, etc... of fluids. (Technici4n)\n- Convention Tags: define standard tags that Fabric mods can use, and register vanilla entries to them. (dexman545)\n- Loot API v2: replacement for the Loot Table API v1, with many improvements. The new version uses interface injection and transitive access wideners to implement most of its functionalities. Additionally, `LootTableLoadingCallback` was replaced with `LootTableEvents.REPLACE` event (for replacing an entire loot table) and `LootTableEvents.MODIFY` event (for modifying part of a loot table). `REPLACE` runs before `MODIFY`, and if one mod replaces a loot table, the callback loop will exit early and no other mod can replace the loot table. (Juuxel)\n- Message API (experimental): server-side manipulation of messages sent to players. (apple502j)\n- And many smaller features and bug fixes.\n\n### Deprecated Fabric API Modules\nFabric API modules that are deprecated (including the aforementioned Loot Table API v1, and the Command API v1) are no longer present in the default Maven artifact. Mods that wish to build against those modules must now depend on `net.fabricmc.fabric-api:fabric-api-deprecated` in `build.gradle` file for them to build successfully:\n\n```groovy\nmodImplementation \"net.fabricmc.fabric-api:fabric-api-deprecated:${project.fabric_version}\"\n```\n\nThis should not impact players in any way, as the jar that is downloaded from CurseForge and Modrinth still contains all the modules.\n\n### Class Loader Isolation and Mixins\nFabric Loader 0.14 improves class loader isolation. This allows Mixins to apply to libraries that the game uses, such as Brigadier, DataFixerUpper, or Authlib. Mods using workarounds to allow mixins to apply to such libraries should remove the workaround.\n\n### Split Client And Common Code\nIn Loom 0.12 and Loader 0.14, an experimental option has been added to require all client code to be moved into its own sourceset: resources and common code will be in `src/main`, while client-only code will be in `src/client`.\nThis provides a compile-time guarantee against calling client-only Minecraft code on the server. When building, Loom still produces a single jar that works on both the client and the server.\n\nTo enable split source sets, add the following to your mod\'s `build.gradle`:\n\n```groovy\nloom {\n   splitEnvironmentSourceSets()\n    mods {\n        modid {\n            sourceSet sourceSets.main\n            sourceSet sourceSets.client\n        }\n    }\n }\n```\n\nAs your mod will now be split across two sourcesets, you will need to use the new DSL to define your mod\'s sourcesets. This enables Fabric Loader to group your mod\'s classpath together.\n\n\n## Minecraft Changes For Mod Developers\n### Text Changes\n\nText should now be created using static methods provided by the `Text` interface rather than by using constructors. For example:\n\n```diff\n- new LiteralText(content);\n- new TranslatableText(key, args);\n+ Text.of(content);\n+ Text.translatable(key, args);\n```\n\nIn Yarn, the old classes are now called text contents (such as `TranslatableTextContent`) because they have been separated from the text structure (style and siblings). Mod developers will rarely need to interact with these text content classes.\n\n### Command Changes\n\nCommand arguments have been refactored to look up registry entries using the `CommandRegistryAccess` class, a wrapper around the registry manager. The registry access is an optimization for handling missing tag references, but must be passed into arguments during command registration:\n\n```diff\n- CommandManager.argument(\"item\", ItemStackArgumentType.itemStack())\n+ CommandManager.argument(\"item\", ItemStackArgumentType.itemStack(registryAccess))\n```\n\nIf you use Fabric API to register commands, you should switch to the version 2 of the Fabric Command API, which contains a major breaking change to provide the registry access. Unlike most of other breaking changes, this is an entirely new API with a new package.\n\n```diff\n- import net.fabricmc.fabric.api.command.v1.CommandRegistrationCallback;\n+ import net.fabricmc.fabric.api.command.v2.CommandRegistrationCallback;\n- CommandRegistrationCallback.EVENT.register((dispatcher, dedicated) -> {\n-    if (dedicated) {\n+ CommandRegistrationCallback.EVENT.register((dispatcher, registryAccess, environment) -> {\n+    if (environment.dedicated) {\n         dispatcher.register(...);\n     }\n  });\n```\n\nWhile version 1 of the API still exists for server-side registration, client commands functionality is no longer present in that version. If you use client commands, you must use version 2, which now uses an event for registration as well:\n\n```diff\n- import net.fabricmc.fabric.api.client.command.v1.ClientCommandManager;\n+ import net.fabricmc.fabric.api.client.command.v2.ClientCommandRegistrationCallback;\n- ClientCommandManager.DISPATCHER.register(...);\n+ ClientCommandRegistrationCallback.EVENT.register((dispatcher, registryAccess) -> {\n+     dispatcher.register(...);\n+ });\n```\n\n### Secure Chat\nMojang has introduced a feature to cryptographically sign chat messages to detect whether the server modified the sent messages. Players sign all chat messages using a Mojang-provided private key, which the server and the clients verify. If the server modifies the message unexpectedly, the message cannot be verified, and clients can opt in to hide those messages.\n\nAlong with this, there were several protocol changes:\n\n- The client now wraps the message with `chat.type.text` message (or the like) instead of the server. To customize this, a custom message type (called \"chat type\" by the game) can be registered. (See below for details.)\n- Commands are sent in a separate packet, not as a slash-prefixed chat message.\n\nThis mostly impacts mods that change the chat message server-side in some ways like translating or coloring. To prevent the messages from being marked as \"unverified\", the mod has to use one of the two options:\n\n- Client-side message decoration. A server can register a custom `MessageType` using a data pack (just like custom world generation), which consists of various \"decorations\" applied to the whole message. [Chat Type Generator](https://misode.github.io/chat-type/) is a third-party tool that can generate the JSON file defining custom message types easily. Then, when sending a message, the mod should pass the registry key of the message type to be used.\n\n```java\nRegistryKey<MessageType> typeKey = RegistryKey.of(Registry.MESSAGE_TYPE_KEY, new Identifier(\"modid\", \"orange\"));\n// when sending\nserver.getPlayerManager().broadcast(Text.of(\"This is in orange!\"), typeKey);\n```\n\n- Server-side message decorator. This can be used to modify the message content itself, as well as the styling applied. Fabric API provides a way to register a custom message decorator.\n\n```java\nServerMessageDecoratorEvent.EVENT.register(\n    // Used to provide better compatibility across mods\n    ServerMessageDecoratorEvent.CONTENT_PHASE,\n    (sender, message) -> {\n        if (message.getString().contains(\"tater\")) {\n            message = message.copy().append(\" :tiny_potato:\");\n        }\n        return CompletableFuture.completedFuture(message);\n    }\n)\n```\n\nNote that to sign the message produced by the message decorator, the server must enable \"chat preview\" by setting `previews-chat=true` in `server.properties`. When clients join such servers, they will receive a warning that the typed message will be sent to show the preview before sending. Clients can disable the chat previews via the options, which causes the decorated part of the message to be marked as \"unsigned\" (but not the original message).\n\nFinally, it is recommended to check the Yarn javadoc, which provides documentation on how chat messages are handled.\n\n### Random Changes\n\nThe JDK `java.util.Random` class has been replaced entirely with Mojang\'s own interface, `net.minecraft.util.math.random.Random`. Several implementations are available to provide different levels of thread safety. For most use cases, `Random.create()` should be used to create the random instance. Note that this random instance is not safe for multithreaded use. <!-- Random.createThreadSafe is deprecated, maybe modders shouldn\'t use random across thread -->\n\n### Option Changes\n\nClient options were completely refactored. There is a class, named `SimpleOption`, that handles everything an option needs - rendering, validation, serialization, etc. An instance holds its name, current value, default value, and a set of callbacks to provide customizable behaviors. For example, a slider-based integer option would use `ValidatingIntSliderCallbacks`, while a button-based option would use `PotentialValuesBasedCallbacks`. To get the value, use `getValue()`, and to set the value while validating, use `setValue()`.\n\n`GameOptions` class holds all options used by the vanilla game.\n\n```java\nGameOptions options = MinecraftClient.getInstance().options;\nGraphicsMode graphicsMode = options.getGraphicsMode().getValue();\noptions.getFov().setValue(80);\n// setValue triggers validation, so this cannot set gamma more than the limit (1.0)\noptions.getGamma().setValue(5.0);\n```\n\n### Tag Changes\n\nThe `Tag` class has been removed, after having been made largely obsolete in 1.18.2 due to the addition of `TagKey`.\n\nThe inner classes, which are still in use, have been moved to `TagBuilder` and `TagEntry`. The remaining usages in functions now use `Collection`. `TagFile` has been added, which is used to refer to a specific tag JSON file.\n\nAdditionally, many vanilla tags have been added or modified in 1.19. Ensure your modded content is in all the applicable tags. For example, villager workstations should now be added to the `minecraft:acquirable_job_site` tag.\n\n### Structure Changes\n\nThe game no longer refers to generated structures as \"configured structure features\". Yarn mapping has renamed and several structure-related classes to handle this change; for example, `StructureFeature` has been renamed to `Structure`.\n\nTo avoid conflicts and to match the terminology used by custom world generation, the old `Structure` class was renamed to `StructureTemplate`, and `StructureManager` is now called `StructureTemplateManager`.\n\n### Seeded Sounds\n\nThe `playSound` methods now have a `seed` parameter. This seed is used to determine which sound is played for a sound event; as a result of this change, two players hearing the same sound event will now hear the same sound. Most mods will not need to change their code to support seeded sounds, as the `playSound` methods are overloaded to provide a default random seed.',0,0,25,'article','2023-02-15 20:19:44','2023-03-15 14:04:26',0),
(10,1,'Fabric for Minecraft 1.18','![Cliffs](https://fabricmc.net/assets/cliffs.png)\n\nMinecraft 1.18: *Caves & Cliffs, Part 2* is now released, and along with it, updates for Fabric itself and many mods already.\n\nThe release of Fabric for Minecraft 1.17 was almost 6 months ago. Since then, we have updated to all 7 experimental snapshots, 8 snapshots, 8 pre-releases, 4 release candidates, and the final release version of Minecraft 1.18.\n\nThis blog post will go over what the 1.18 update means for both players and developers.\n\n## For Players\n\nPlayers should use Fabric Installer 0.9.0 and Fabric Loader 0.12.5 (at the time of writing) to play on Minecraft 1.18.\n\nHundreds of mods have already been updated to support 1.18 and we expect there will be many new and updated mods being released soon. We kindly ask that you be patient as mod developers update their mods.\n\n### All of Fabric 5 Modpack\n\n![AOF 5](https://fabricmc.net/assets/aof5.png)\n\nThe fifth edition of the All of Fabric modpack will be available on CurseForge very soon.\n\nAOF5 includes a wide selection of 1.18 Fabric mods. It will continue to receive updates as mods get ported, and new mods get created.\n\n## For Mod Developers\n\nVarious technical changes have been made in both Minecraft and Fabric that will affect mod development for 1.18.\n\nAs always, you can use [the versions page](https://fabricmc.net/versions.html) to determine the recommended versions of Yarn, Fabric Loader, Fabric API, and Loom for any version of Minecraft.\n\n### Java 17\n\nOnce again, Minecraft has updated its Java version, this time to Java 17. This means mods can be compiled for Java 17 and use the latest features.\n\nWhile not as large a step up as the previous move to Java 16 made in 1.17, Java 17 still provides some new features that can be used, such as Sealed Classes.\n\nTo set up a development environment you will need to use Java 17, Loom 0.10, and Gradle 7.3 or higher. If you need some help getting set up, please go to `#mod-dev-gradle-ides` on the [official Discord server](https://discord.gg/v6v4pMv).\n\nSee [this commit](https://github.com/FabricMC/fabric-example-mod/commit/57e84b576d24f1b80e1701d4759773234b1ee8ba) for an example of how the example mod was updated to accomodate this change.\n\n### Fabric API\n\nFabric API has been fully updated to Java 17 and 1.18.\n\nSince 1.17 released, we have added a number of new APIs that can be used:\n* Fluid and Item Transfer API. (Technici4n)\n* Tag Factory API, allows making tags for any registry (deirn)\n* Add sleeping events. (Juuxel)\n* Add flattening, stripping and tilling registries. (Juuxel)\n* Add a Game Test API to allow the use of Mojang\'s testing framework. (modmuss50)\n* Add tag-based mining level API, fix and deprecate FabricBlockSetting.breakByTool. (Juuxel)\n* Add event phases to allow ordering between listeners. (Technici4n)\n* Add DimensionRenderingRegistry to register custom renderers for the sky or weather. (Waterpicker)\n* Add custom fluid renderers and enhanced vanilla fluid renderer customisation. (FoxShadew)\n* Add elytra flight API (Technici4n)\n* Add Oxidizable and Waxable Blocks registries (Shnupbups)\n* a variety of smaller or more focused additions and enhancements ([see GitHub](https://github.com/FabricMC/fabric/commits/1.18))\n\nMost of these new features have also been added to the 1.17 version of Fabric API.\n\n### World Generation\n\nMinecraft 1.18 overhauls many systems used in world generation. Any mods that include world generation will, as a result, need to adjust to these changes.\n\nIf you need some help with these changes, please go to `#mod-dev-worldgen` on the [official Discord server](https://discord.gg/v6v4pMv).\n\n\n### Yarn\n\nSince 1.17.1, there have been almost 200 commits to Yarn from many contributors, all working to improve coverage and quality.\n\nTrying to document the Minecraft codebase is a massive job, especially as it is constantly evolving. Improving the documentation provided by Yarn is an ongoing effort by all of the contributors.\n\nYou can view the online Javadoc for 1.18 Release Candidate 4 [here](https://maven.fabricmc.net/docs/yarn-1.18-rc4+build.1/) or inline with the decompiled and named Minecraft sources directly attached in your IDE.',0,0,26,'article','2023-02-15 20:22:16','2023-03-15 14:04:26',0),
(11,1,'Fabric Loader 0.12','This release is a major overhaul of the core features in Fabric Loader, including everything that deals with finding and choosing mods. Users should benefit from greatly improved error messages and quite a few options to customize their install. Mods have several new tools to achieve their goals more easily.\n\nFabric Loader 0.12 is not yet available through the normal means, see below for how to get it.\n\n#### Changelog\n- added support for the bundler based server distribution introduced by the MC snapshot 21w39a (Player)\n- added support for global access wideners (shartte)\n- added ObjectShare mechanism for mods to interact indirectly (Player)\n- changed package structure for clear api/implementation split, may break some mods that use internals beyond what is now provided by legacy support API (Player)\n- changed project structure to isolate MC specific code, runtime test dependencies and legacy API (modmuss50)\n- fixed mod dependency inspection API and made it more useful (Player)\n- updated Mixin (modmuss50, Player)\n- added Mixin backwards compatibility mechanism, Mixin behavior will depend on the minimum fabricloader version requested by the mod\'s dependency definition (Player)\n- changed mod discovery for better reliability, speed and memory efficiency (Player)\n- added `fabric.addMods` system property and argument to configure additional mod sources: individual jar files, directories containing jars, directories representing an extracted mod or `@`-prefixed files listing the previous one line at a time (Player)\n- changed mod resolution to gracefully handle multiple instances of the same mod, produce better errors, give mod dependency issue guidance, handle nested jars properly and allow for more customization (Player)\n- changed mod load order to be random in-dev (see `fabric.debug.disableModShuffle` system property) and explicitly sorted by mod id in production (not a specification, may change without notice) (Player)\n- added system property `fabric.debug.loadLate` to work around mod load order bugs (Player)\n- added `fabric.debug.throwDirectly` system property to let errorneous entrypoints fail immediately, helps debugging them through isolation (Player)\n- changed exposing the game and its libraries to be as late as possible to prevent accidental too-early accesses (Player)\n- dropped most library dependencies to avoid conflicts with the game (modmuss50, Player)\n- added exception display to the error screen and made it show for crashes too early for MC to normally display by itself (Chocohead)\n- added error screen support for MacOS (Player)\n- fixed various MacOS error screen issues including the dock icon, title, dark mode, stuck on close (modmuss50)\n- fixed normalization of special MC versions like combat test, april fools or experimental releases (Chocohead)\n- various smaller changes and fixes\n\n## How to test\n\nDue to the size of the changes we are releasing this version in stages, once we are happy everything is working we will release it to everyone. If you do find an issue please make sure to report it on our [Github Repository](https://github.com/FabricMC/fabric-loader/issues).\n\nInitially the installer won\'t offer Loader 0.12 by itself, it has to be installed as follows:\n\n1. Go to [https://fabricmc.net/use/](https://fabricmc.net/use/). \n2. Click \"Show other versions\" and select `0.8.0`, download the installer\n3. Download Fabric Loader 0.12.0 from here: [fabric-loader-0.12.0.jar](https://maven.fabricmc.net/net/fabricmc/fabric-loader/0.12.0/fabric-loader-0.12.0.jar)\n4. Run the installer and go to the Client or Server tab as desired\n5. Select the desired Minecraft version as usual\n6. Select `(select custom)` at the very bottom of the Loader Version list\n7. Configure anything else as desired and start the install as usual by using the Install button\n8. The installer will now ask for the Fabric Loader JAR, provide it with the one downloaded in step 3\n\nA Fabric Installer version older than 0.8.0 will not support this procedure.\n\n\n#### Mod Developers\n\n1. Ensure you are using Loom 0.7 or higher. Loom 0.10 is required to use transitive access wideners and develop on 1.18 snapshots.\n2. Change your loader version in `gradle.properties` to be `0.12.0` and reload your gradle project.\n\n## Mod resolution changes\n\nFabric Loader 0.12.0 will no longer refuse multiple versions of the same mod, some but not all of these may even have unmet dependencies. It will select the latest compatible version if more than one option is present.\n\nIf mod resolution fails due to unmet dependencies Loader will now try to compute a possible solution in addition to only stating what the issue was. It also tries to come up with a much better error message than before, unhelpful \"empty clause\" errors should be gone.\n\n## `fabric.debug.loadLate`\n\nSometimes mods make false assumptions about the load order of mods, which limits their compatibility unintentionally. Mod load order is not specified and depends on implementation details that may change with a Fabric Loader release. Version 0.12 is one of these and it is impractical to emulate the old behavior.\n\nWe have added a workaround for load order bugs in the form of the `fabric.debug.loadLate` system property, which will delay the specified mods to load later than all other mods. For example, if `someMod` required a block from another mod that\'s being created in the same startup phase, adding `-Dfabric.debug.loadLate=someMod` moves `someMod` behind all other mods, including the one supplying the block it needs.\n\n## `fabric.addMods`\n\nFabric Loader normally loads mods from the mods directory, the `fabric.addMods` system property or game argument allows specifying more. It takes a list of paths separated by the operation system specific path separator (`;` on Windows, `:` elsewhere).\n\nSupported options for the paths are:\n- mod jar location\n- directory location containing mod jars (searched recursively)\n- directory location containing an unpacked mod (for development purposes, detected by the presence of fabric.mod.json)\n- mod list file location prefixed by `@`, e.g. `-Dfabric.addMods=@/path/to/extraMods.txt`\n\nA mod list file contains any of the above supported paths except another mod list file, one per line.\n\nPaths can be absolute or relative to the working directory.\n\n## Mixin compatibility\n\nMixin has been changing its implementation in such a way that mixins that are correct and working on one version may no longer work correctly or at all in a newer version. This was necessary to fix bugs in its local variable detection logic.\n\nFabric adds a mechanism to emulate the Mixin behavior bundled with the least Loader version a mod depends upon. If the mod requires an old Loader version (or none at all), its Mixins will be processed in line with the old Mixin behavior. If it however depends on Loader 0.12.0, which comes with Fabric Mixin 0.10.2+mixin.0.8.4, it\'ll use the native behavior that comes with that release and currently represents the latest&greatest.\n\nMods are highly encouraged to declare the minimum Fabric Loader dependency to reflect the minimum version they were tested against. If they need the latest Mixin behavior and fixes, they also need to depend on the latest fabricloader version explicitly.\n\nFor Fabric Loader 0.12.0 this can be done as follows:\n\n1. In the `fabric.mod.json` add the following dependency\n\n```json=\n\"depends\": {\n   \"fabricloader\": \">=0.12.0\"\n}\n```\n\nThe lack of suitable dependency declaration will always force-enable legacy behavior for the respective mod! This is undesirable for newly developed mods, but keeps older mods working.\n\n## `ObjectShare`\n\nThe object share is very similar to a String-indexed Java `Map` with arbitrary values. It offers the usual `get`/`put`/`putIfAbsent`/`remove` operations and additionally `whenAvailable` to listen for additions in cases without clear ordering.\n\nIts primary purpose is inter-mod communication. One mod can put some data into it, another mod can pull it back out. Active interactions are possible by publishing and using objects with interfaces like `Function` or `Consumer`.\n\nContrary to any regular API the object share allows mod interaction without even a compile time dependency, removing friction for simple purposes. This case requires commonly available types/interfaces like the ones provided by Java, Minecraft or Fabric API (String, Integer, List, Map, Identifier, NbtCompound, Event, ...). Custom types are of course still possible, but don\'t carry these benefits.',0,0,18,'article','2023-02-15 20:23:24','2023-03-15 14:04:24',0),
(12,1,'Fabric for Minecraft 1.17','Minecraft 1.17: _Caves & Cliffs, Part 1_ is now released, and along with it, Fabric itself and many mods already.\n\nThe release of [Fabric for Minecraft 1.16](https://fabricmc.net/2020/06/23/116.html) was almost a year ago. Since then, we have updated to all 48 snapshot and release versions of Minecraft. We recently released a [blog post](https://fabricmc.net/2021/05/27/117-for-developers.html) covering what the 1.17 update means for mod developers.\n\n## All Of Fabric 4 Modpack\n\n![AOF 4](https://fabricmc.net/assets/aof4.png)\n\nThe fourth edition of the All Of Fabric modpack will available on Curseforge very soon.\n\nAOF4 includes a wide slection of 1.17 Fabric mods. It will continue to receive updates as mods get ported, and new mods get created.',0,0,26,'article','2023-02-15 20:34:30','2023-03-15 14:04:26',0),
(13,1,'Minecraft 1.17 for Mod Developers','\nMinecraft 1.17 has just entered its pre-release cycle meaning that a full stable release is only a few weeks away. When it is released we will have a player-oriented blog post, this post is aimed towards mod developers.\n\nThe pre-releases are a great time to start updating your mods in preparation for the final release. In the past most mods updated during the pre-release stage kept working on the final stable release with few or no further changes.\n\n![A goat in a geode](https://fabricmc.net/assets/goat.png)\n\n## Java 16\n\nMinecraft 1.17 is now built against Java 16; this is a big step up from Java 8 and will affect modders. To set up a development environment you will need to use Java 16, Gradle 7 and fabric-loom 0.8 or higher. In most cases this will not break your existing code (excluding the normal porting procedure). There is a 1.17 branch of the [fabric-example-mod](https://github.com/FabricMC/fabric-example-mod/tree/1.17) that should help get you started. Look at the [1.17+Java 16 migration changes](https://github.com/FabricMC/fabric-example-mod/compare/29c522536fc16233833221e22eed3f106c0726bc...1.17) which should apply similarly to most mods. We have created a specific channel named `#mod-dev-gradle-ides` on the [official Discord server](https://discord.gg/v6v4pMv) if you need some help with getting setup.\n\nWe have used this opportunity to migrate most of the modder- and contributor-facing tools to Java 16. Player-facing projects only use Java 16 if Minecraft doesn\'t require it anyway in all relevant scenarios. The Fabric Loader and Installer, and their dependency libraries, will still target Java 8 as they are cross-version.\n\n## Fabric API\n\nFabric API has been fully updated to Java 16 and 1.17. It doesn\'t use any Java 16 features yet, nor will it break compatibility to adopt any. New or updated modules may introduce records and other features into the API where it makes sense, the implementation is expected to use Java 16 features where it doesn\'t harm necessary backporting too much.\n\nSince 1.16 released, we have added a number of new APIs that can be used:\n\n- Reworked networking API, closer to what the vanilla network protocol allows (i509VCB, liach)\n- World Renderer events for a variety of hooks to render custom world content outside the usual facilities and some behavior modification opportunities to e.g. customize block outlines (grondag)\n- Screen API with many events to react to or influence behavior in GUIs (i509VCB)\n- Client Side Commands to use command input for client purposes like visual config changes (Juuxel)\n- API Lookup API to obtain API references without having to attach interfaces to classes directly and help with context binding, a building block for universal APIs like Fluid I/O (Technici4n)\n- a variety of smaller or more focused additions and enhancements (see GitHub)\n\n\n## Yarn\n\n### Constants\n\nIn 1.17, Mojang no longer strips out unused code including the constant fields that are inlined by the Java compiler. We have seamlessly integrated [unpick](https://github.com/FabricMC/unpick) (created by Daomephsta) into the Fabric toolchain to undo some of this inlining. Once you have updated your development environment to 1.17, you can also use these constants in your mod code just like you would with any other field.\n\n#### Before\n\n*Note the hard to understand flag `26` passed into the last parameter of setBlockState*\n\n```java=\nprotected boolean place(ItemPlacementContext context, BlockState state) {\n   return context.getWorld().setBlockState(context.getBlockPos(), state, 26);\n}\n```\n\n#### After\n\n*In 1.17 this has been simplified to clearly show the true meaning of this flag.*\n\n```java=\nprotected boolean place(ItemPlacementContext context, BlockState state) {\n   return context.getWorld().setBlockState(context.getBlockPos(), state, Block.NOTIFY_LISTENERS | Block.REDRAW_ON_MAIN_THREAD | Block.FORCE_STATE);\n}\n```\n\n\n### Names\n\nDuring the 1.17 snapshot season, some important classes have been renamed in Yarn.\n\nThe most notable instance is the rename of all NBT-related classes thanks to contributor [@LambdAurora](https://github.com/LambdAurora). This is to prevent confusion between the data-driven [`net.minecraft.tag.Tag`s](https://minecraft.fandom.com/wiki/Tag) and NBT tag interface `net.minecraft.nbt.Tag`, which is now named `NbtElement` instead.\n\nYou can use the automated [migrateMappings](https://fabricmc.net/wiki/tutorial:migratemappings) task in Loom to transition to the new names efficiently. Since 1.16.5, there have been over 500 commits to Yarn, all working to improve coverage and quality. Major class renames will be paused when 1.17 is released; these will be done in the 1.18 snapshots instead.\n\n\n### Documentation\n\nTrying to document the Minecraft codebase is a massive job, especially as it is constantly evolving. Improving the documentation provided by Yarn is an ongoing effort by all of the contributors. You can view the online Javadoc for 1.17 pre-release 1 [here](https://maven.fabricmc.net/docs/yarn-1.17-pre1+build.1/index.html) or inline with the decompiled and named Minecraft sources directly attached in your IDE.\n\n## CurseForge\n\nCurseForge have recently announced in their [May Updates blog post](https://mailchi.mp/844b51b9bdf1/whats-new-with-overwolf-curseforge-may2-edited) that they will be adding native Fabric support to their client. In preparation for this, they have asked all mod developers to ensure that uploaded files are correctly tagged against the relevant mod loader. The linked blog post contains details on how to do this.\n',0,0,24,'article','2023-02-15 20:35:20','2023-03-15 14:04:26',0),
(14,1,'Fabric for Minecraft 1.16.2','![](https://i.imgur.com/b8LYWAM.png)\n\nFabric for Minecraft 1.16.2 has been released! The 1.16.2 update is a larger than expected as it includes new features and major refactors to parts of the code.\n\nBiomes were at the center of these changes, thus any mod adding biomes may require a significant amount of work to update. Due to these changes, Fabric API\'s biome module was removed. We plan to work with mod developers to create an updated biome api as the requirements become clear.\n\nDue to a number of other smaller changes we expect most mods will require an update to 1.16.2.\n\nIf you want to read more about the 1.16 update please see our [Fabric for Minecraft 1.16](https://fabricmc.net/2020/06/23/116.html) blog post. If you wish to discuss the update our [Discord server](https://discord.gg/v6v4pMv) is a good place to do so.\n\n## For the mod developers\n\nFabric API has gained a few new features during the last round of snapshots:\n\n- A new lifecycle events module:\n    - This contains new events such as a chunk and world (un)load event for both the client and server.\n    - This replaces the old `fabric-events-lifecycle-v0` module.\n- An api to register custom game rules\n    - Game rules registered using this api appear in the new `Edit Game Rules` screen.\n- An api to register additional things to be rendered on an entity\n    - This makes rendering things like hats on entities much easier to implement.\n- Many smaller bug fixes and improvements',0,0,14,'article','2023-02-15 20:35:57','2023-03-15 14:04:17',0),
(15,1,'June Status Update','![](https://i.imgur.com/B3zWLoL.jpg)\n\n\n1.16 pre-releases have begun, and with it comes a new wave of updates for the Fabric toolchain. There are several new key things you should be aware of, including breaking changes from the base game, new Fabric API features, and faster versions of developer tools.\n\nNow is a great time to start thinking about updating your mods to the 1.16 pre-releases as it will allow a fast and smooth transition to the full 1.16 release.\n\nA more player-focused blog post will be released alongside the Minecraft 1.16 official release. In the meanwhile feel free to join the [Discord Server](https://discord.gg/v6v4pMv) to see some of the awesome mods and creations people are making!\n\n## Improvements\n\nFabric has received a large number of improvements and bug fixes over the last few months, which will greatly improve the developer experience. Most of these contributions came from members of the community via pull requests.\n\n### Loom\n\nLoom is the Gradle plugin used by all fabric mods to make setting up a development environment easier, and building a releasable  jar as painless as possible \n\nLoom 0.4 brings performance improvements, new features, and bug fixes to the table. One of the greatest improvements to Loom from the past few months is support for multi-threading in several operations, which greatly improves speed. A test on medium-tier hardware<sup>1</sup> reveals a 600%+ speed improvement on `genSources` between Loom `0.2.7-SNAPSHOT`, which took 3m4s, and the most recent version, `0.4-SNAPSHOT`, which took an incredible 27s. \n\nImprovements were also made with startup times: all dependencies are now remapped at once instead of one by one. This saved over 30 seconds during testing and was made possible through improvements to [tiny-remapper](https://github.com/FabricMC/tiny-remapper).\n\n#### Updating Loom\n\nUpdating your projects to use a newer version of Loom is easy! Locate the area at the top of your `build.gradle` file where you pull Fabric Loom as a plugin:\n\n```groovy\nplugins {\n    id \'fabric-loom\' version \'0.2.7-SNAPSHOT\'\n}\n```\n\nReplace the existing version with your target version. In this example, we will update to `0.4-SNAPSHOT`:\n\n```groovy\nplugins {\n    id \'fabric-loom\' version \'0.4-SNAPSHOT\'\n}\n```\n\nYou can view how the [Fabric Example Mod](https://github.com/FabricMC/fabric-example-mod) was updated [here](https://github.com/FabricMC/fabric-example-mod/commit/8d952c922d566bd386d76108c222baa2e2cc5d33).\n\n---\n\n### Yarn\n\n[Yarn](https://github.com/FabricMC/yarn) has continued to progress at a rapid rate throughout the 1.16 snapshot cycle and grows ever closer to 100% mapping coverage. As of 1.16-pre2, yarn statistics are as follows:\n\n| Category        | Progress         |\n| --------------- | ---------------- |\n| Classes         | 100%            |\n| Methods         | 95.71%            |\n| Fields          | 95.54%            |\n\n\n\n#### Big Renames\n\nBased on developer feedback, some larger-scale class renames have been applied to 1.16 yarn:\n\n| Previous Name   | New Name         |\n| --------------- | ---------------- |\n| BasicInventory  | [SimpleInventory](https://github.com/FabricMC/yarn/pull/1364)  |\n| Container       | [ScreenHandler](https://github.com/FabricMC/yarn/pull/1106)    |\n| ContainerScreen | [HandledScreen](https://github.com/FabricMC/yarn/pull/1106/files)    |\n| IWorld          | [WorldAccess](https://github.com/FabricMC/yarn/pulls?q=is%3Apr+is%3Aclosed+WorldAccess)      |\n\n\nYou can automatically update your mods source code to the new names using Loom\'s `migrateMappings` task. You can contribute to yarn by visiting the [GitHub repository](https://github.com/FabricMC/yarn).\n\nA big thanks goes out to over 30 contributors who have helped create these mappings since the first 1.16 snapshot!\n\n---\n\n### Fabric (API)\n\n[Fabric API](https://github.com/FabricMC/fabric), the core library that powers a lot of Fabric mods, has received numerous updates over the past 6 months. It has been updated weekly since the beginning of February for the 1.16 snapshots, covering 16 snapshot versions and 2 pre-releases, as of the start of June. A lot of the mentioned changes below are also in the 1.14 and 1.15 builds.\n\n#### Villager Profession API\n\n[i509VCB\'s Villager Profession API](https://github.com/FabricMC/fabric/pull/493), which eases the creation of Villager Professions and Point of Interests, was recently merged into Fabric API. \n\n#### Object Builders \n\nThe Object Builders module has successfully transitioned from [v0 to v1](https://github.com/FabricMC/fabric/pull/537) thanks to the efforts of i509VCB and others, paving the way for more API utilities in the future.\n\n#### Nether Biome API\n\nThe first 1.16 snapshot, 20w06a, which was released on February 5th, was quickly followed by [SuperCoder7979\'s Nether Biome API](https://github.com/FabricMC/fabric/pull/496) on the 6th. This API allows developers to easily add their custom biomes to the Nether. \n\n#### Improved Commands API\n\nThe original API used to add commands was one of the oldest modules in fabric and was due a refresh to bring it upto date. Thanks to i509VCB [Fabric Command API v1](https://github.com/FabricMC/fabric/pull/539) was added while maintaining backwards compatibility for existing mods. \n\n#### Tool Attributes\n\nThe new [tool attribute](https://github.com/FabricMC/fabric/pull/460) module is designed to replace the old mining level module. As with the other modules backwards compatibility was kept for older mods. Thanks to Boundarybreaker and shedaniel for helping with this. \n\n#### Other Changes\n\nThere are too many changes to list in detail, bellow are links to some smaller changes that are also included:\n\n* [Various Indigo fixes](https://github.com/FabricMC/fabric/pull/640) (grondag)\n* [Model predicate provider registry](https://github.com/FabricMC/fabric/pull/601) (liach)\n* [Restart testmods](https://github.com/FabricMC/fabric/pull/593) (modmuss50)\n* [Builtin item renderer registry](https://github.com/FabricMC/fabric/pull/563/) (Juuxel)\n* [Improvements to the registry sync](https://github.com/FabricMC/fabric/pull/525) (modmuss50)\n* [Entity attribute registry](https://github.com/FabricMC/fabric/pull/568) (liach)\n\n#### Breaking Changes\n\nDespite our best efforts, some parts of Fabric API will be broken with the 1.16 update. The most notable change is in **`FabricDimensionType`** due to the conversion of dimensions and dimension types to being data-driven. We are not currently sure what can be kept and what must be removed. `fabric-climbable-api-v1` has also been removed, as it was purely a backport of 1.16\'s `minecraft:climbable` tag.\n\nSome of the modules originally developed targeting 1.16 have already been backported to 1.15, like the new version 1 of Fabric Object Builders.\n\n---\n\n### Enigma\n\n[Enigma](https://github.com/FabricMC/enigma) is the tool that is used to map out the Minecraft codebase. Over the last few months, members of the community have worked hard to improve it in *many* areas.\n\n#### GUI Improvements\n\n2xsaiko has worked hard to bring one of the most requested features to Enigma: [Tab support](https://github.com/FabricMC/Enigma/pull/238)! You can now open multiple files at the same time, resulting in faster workflows and an overall better experience.\n\n![](https://i.imgur.com/7iTKHzs.png)\n\n\n#### Multiplayer\n\nEarthcomputer worked on a fun [pull request to add multiplayer support](https://github.com/FabricMC/Enigma/pull/221), or as he puts it, \"~~battle royale~~ real-time collab support\".\n\nTo access this feature, open a jar in Enigma, and click the *Collab* option at the top of the screen:\n\n![](https://i.imgur.com/CedYVnt.png)\n\n\n#### Modularity\n\nRunemoro [split the code base of Enigma](https://github.com/FabricMC/Enigma/pull/242) into 4 distinct sections. The new 4 modules of Enigma include `enigma`, `enigma-swing`, `enigma-server`, and `enigma-cli`. This will make it easier to continue to improve enigma as well as write tools that use parts of it.\n\n## ModFest\n\nThe 1.15 [ModFest](https://modfest.net/1.15/entries/) event, which ran from March 28<sup>th</sup> to April 5<sup>th</sup>, will be followed by another ModFest centered around 1.16. ModFest 1.16 runs from **June 12<sup>th</sup>** and **June 21<sup>st</sup>**, 2020. You can stay up to date on ModFest news by joining the [ModFest Discord server](https://discord.gg/gn543Ee). The player blog post, which will arrive in the near future, will further document the results of the ModFest 1.15.\n\n### Notes\n1. Tests were performed on an RX 590 with a Ryzen 3600 and 16GB allocated to IntelliJ IDEA under standard conditions.\n',0,0,13,'article','2023-02-15 20:36:37','2023-03-15 14:07:22',0),
(16,1,'Fabric for Minecraft 1.16','![](https://i.imgur.com/tJ98rRc.jpg)\n\nThe long anticipated Minecraft 1.16 update has arrived, and along with it, Fabric!\n\nIt has been almost **a year and a half** since we [initially unveiled Fabric on the 10th of December, 2018](https://fabricmc.net/2018/12/10/announcement.html). Since then, the world has changed in many ways, and so has Fabric. Since the Minecraft 1.15 update over six months ago, Fabric has:\n\n- Updated to every single snapshot along the way to allow developers to explore the new versions\n- Continued to add many new APIs allowing for easier mod making and mod inter-compatibility\n\nDevelopers, make sure to check out our [June Status Update](https://fabricmc.net/2020/06/08/jun-status-update.html) from a couple weeks ago to learn more about how Fabric has progressed internally over the past six months.\n\n## Community <!-- Player oriented, so maybe tell them where to grab fresh mods! -->\n\n\n### All of Fabric Modpack\n\n![](https://i.imgur.com/c1tcdOF.png)\n\nAOF is back for the 3rd time with [All of Fabric 3](https://www.curseforge.com/minecraft/modpacks/all-of-fabric-3) running on 1.16! It\'ll be available on Curseforge short after this Blog Post is released.\n\nAll of Fabric 3 currently offers over 60 mods to play around with. It will continue to receive constant updates throughout the next couple of weeks offering the latest & best of Fabric on 1.16.\n\n\n### Mods\nThere are almost 1,000 mods [available for Fabric on CurseForge](https://www.curseforge.com/minecraft/mc-mods?filter-game-version=2020709689%3A7499&filter-sort=4), with *over 400* of those mods being available for the 1.16 snapshots. The community has created a vast amount of content for the snapshots and has also worked together to port mods from previous versions up. Here are a few of the blog team\'s top highlights:\n\n#### Art of Alchemy\n\n![](https://i.imgur.com/pz5mT84.png)\n\n[Art of Alchemy](https://www.curseforge.com/minecraft/mc-mods/art-of-alchemy), written by SynthRose, is a brand new mod centered around transmutation. The mod provides several devices that you, the alchemist, can utilize as you progress through the mod. The mod\'s fantastic textures, intriguing lore, and fancy materials are the perfect ingredients for any magical world.\n\n#### Sandwichable\n\n![](https://i.imgur.com/viKG7DN.png)\n\n[Sandwichable](https://www.curseforge.com/minecraft/mc-mods/sandwichable) is a mod written by FoundationGames that allows you to create fully customizable sandwiches in Minecraft. It provides kitchen essentials such as cutting boards, toasters, and knives, while also introducing new crops to use in your sandwiches. Cheese lovers will appreciate the variety of cheese choices available and bask in the abundance of grilled cheese varieties.\n\n![](https://i.imgur.com/cRVdDPv.png)\n\n\n#### World Gen Tweaker\n\n![](https://i.imgur.com/sTuVw8x.png)\n\n[World Gen Tweaker](https://www.curseforge.com/minecraft/mc-mods/world-gen-tweaker) by SuperCoder79 allows users to modify vanilla and mod biomes through a scripting language.\n\n#### Lil Tater Reloaded\n\nLil Tater is back with force in [*Lil Tater Reloaded*](https://www.curseforge.com/minecraft/mc-mods/lil-tater-reloaded), a mod written by Yoghurt4C. Players can customize their *very own* Lil Tater with a variety of options, including skins, rotations & transforms, and equipment.\n\n*Pictured: a tater making his favorite cheese n\' potato sandwich.*\n\n![](https://i.imgur.com/ayqTPsU.png)\n\n### ModFest\nModFest is a modding event that tries to push modding forward and create new mods as new Minecraft releases arrive. As of the time of writing this is ModFest 1.16 and still ongoing. If you want new mods for a new Minecraft, make sure to check out [ModFest\'s website](https://modfest.net/1.16/)! \n',0,0,13,'article','2023-02-15 20:40:54','2023-03-15 14:07:22',0),
(17,1,'Fabric for Minecraft 1.15.2','# Fabric for Minecraft 1.15.2\n\nFabric for Minecraft 1.15.2 has been released, the first update of the new year!\n\nA few mods may need updating mainly due to some minor item rendering changes, and minor sapling generation changes. However the majority of mods should work just fine. \n\nIf you want to find out more about the 1.15 update please read the [Fabric for 1.15 announcement](https://fabricmc.net/2019/12/10/115.html). Feel free to join our [Discord](https://discord.gg/v6v4pMv) server if you want to discuss the update.',0,0,13,'article','2023-02-15 20:41:26','2023-03-15 14:07:22',0),
(18,1,'markdown cheatsheet','Markdown Cheatsheet\n===================\n\n- - - - \n# Heading 1 #\n\n    Markup :  # Heading 1 #\n\n    -OR-\n\n    Markup :  ============= (below H1 text)\n\n## Heading 2 ##\n\n    Markup :  ## Heading 2 ##\n\n    -OR-\n\n    Markup: --------------- (below H2 text)\n\n### Heading 3 ###\n\n    Markup :  ### Heading 3 ###\n\n#### Heading 4 ####\n\n    Markup :  #### Heading 4 ####\n\n\nCommon text\n\n    Markup :  Common text\n\n_Emphasized text_\n\n    Markup :  _Emphasized text_ or *Emphasized text*\n\n~~Strikethrough text~~\n\n    Markup :  ~~Strikethrough text~~\n\n__Strong text__\n\n    Markup :  __Strong text__ or **Strong text**\n\n___Strong emphasized text___\n\n    Markup :  ___Strong emphasized text___ or ***Strong emphasized text***\n\n[Named Link](http://www.google.fr/ \"Named link title\") and http://www.google.fr/ or <http://example.com/>\n\n    Markup :  [Named Link](http://www.google.fr/ \"Named link title\") and http://www.google.fr/ or <http://example.com/>\n\n[heading-1](#heading-1 \"Goto heading-1\")\n    \n    Markup: [heading-1](#heading-1 \"Goto heading-1\")\n\nTable, like this one :\n\nFirst Header  | Second Header\n------------- | -------------\nContent Cell  | Content Cell\nContent Cell  | Content Cell\n\n```\nFirst Header  | Second Header\n------------- | -------------\nContent Cell  | Content Cell\nContent Cell  | Content Cell\n```\n\nAdding a pipe `|` in a cell :\n\nFirst Header  | Second Header\n------------- | -------------\nContent Cell  | Content Cell\nContent Cell  | \\|\n\n```\nFirst Header  | Second Header\n------------- | -------------\nContent Cell  | Content Cell\nContent Cell  |  \\| \n```\n\nLeft, right and center aligned table\n\nLeft aligned Header | Right aligned Header | Center aligned Header\n| :--- | ---: | :---:\nContent Cell  | Content Cell | Content Cell\nContent Cell  | Content Cell | Content Cell\n\n```\nLeft aligned Header | Right aligned Header | Center aligned Header\n| :--- | ---: | :---:\nContent Cell  | Content Cell | Content Cell\nContent Cell  | Content Cell | Content Cell\n```\n\n`code()`\n\n    Markup :  `code()`\n\n```javascript\n    var specificLanguage_code = \n    {\n        \"data\": {\n            \"lookedUpPlatform\": 1,\n            \"query\": \"Kasabian+Test+Transmission\",\n            \"lookedUpItem\": {\n                \"name\": \"Test Transmission\",\n                \"artist\": \"Kasabian\",\n                \"album\": \"Kasabian\",\n                \"picture\": null,\n                \"link\": \"http://open.spotify.com/track/5jhJur5n4fasblLSCOcrTp\"\n            }\n        }\n    }\n```\n\n    Markup : ```javascript\n             ```\n\n* Bullet list\n    * Nested bullet\n        * Sub-nested bullet etc\n* Bullet list item 2\n\n~~~\n Markup : * Bullet list\n              * Nested bullet\n                  * Sub-nested bullet etc\n          * Bullet list item 2\n-OR-\n Markup : - Bullet list\n              - Nested bullet\n                  - Sub-nested bullet etc\n          - Bullet list item 2 \n~~~\n\n1. A numbered list\n    1. A nested numbered list\n    2. Which is numbered\n2. Which is numbered\n\n~~~\n Markup : 1. A numbered list\n              1. A nested numbered list\n              2. Which is numbered\n          2. Which is numbered\n~~~\n\n- [ ] An uncompleted task\n- [x] A completed task\n\n~~~\n Markup : - [ ] An uncompleted task\n          - [x] A completed task\n~~~\n\n- [ ] An uncompleted task\n    - [ ] A subtask\n\n~~~\n Markup : - [ ] An uncompleted task\n              - [ ] A subtask\n~~~\n\n> Blockquote\n>> Nested blockquote\n    Markup :  > Blockquote\n              >> Nested Blockquote\n_Horizontal line :_\n- - - -\n\n    Markup :  - - - -\n\n_Image with alt :_\n\n![picture alt](http://via.placeholder.com/200x150 \"Title is optional\")\n\n    Markup : ![picture alt](http://via.placeholder.com/200x150 \"Title is optional\")\n\nFoldable text:\n\n<details>\n  <summary>Title 1</summary>\n  <p>Content 1 Content 1 Content 1 Content 1 Content 1</p>\n</details>\n<details>\n  <summary>Title 2</summary>\n  <p>Content 2 Content 2 Content 2 Content 2 Content 2</p>\n</details>\n\n    Markup : <details>\n               <summary>Title 1</summary>\n               <p>Content 1 Content 1 Content 1 Content 1 Content 1</p>\n             </details>\n\n```html\n<h3>HTML</h3>\n<p> Some HTML code here </p>\n```\n\nLink to a specific part of the page:\n\n[Go To TOP](#TOP)\n   \n    Markup : [text goes here](#section_name)\n              section_title<a name=\"section_name\"></a>    \n\nHotkey:\n\n<kbd>⌘F</kbd>\n\n<kbd>⇧⌘F</kbd>\n\n    Markup : <kbd>⌘F</kbd>\n\nHotkey list:\n\n| Key | Symbol |\n| --- | --- |\n| Option | ⌥ |\n| Control | ⌃ |\n| Command | ⌘ |\n| Shift | ⇧ |\n| Caps Lock | ⇪ |\n| Tab | ⇥ |\n| Esc | ⎋ |\n| Power | ⌽ |\n| Return | ↩ |\n| Delete | ⌫ |\n| Up | ↑ |\n| Down | ↓ |\n| Left | ← |\n| Right | → |\n\nEmoji:\n\n:exclamation: Use emoji icons to enhance text. :+1:  Look up emoji codes at [emoji-cheat-sheet.com](http://emoji-cheat-sheet.com/)\n\n    Markup : Code appears between colons :EMOJICODE:\n',0,0,10,'article','2023-02-15 20:50:12','2023-03-15 14:07:22',0),
(19,1,'\"Some intrusive holders were not added to registry\" - Game opens and closes immediately','I\'ve tried troubleshooting myself and searching for any recent solution for this error, but I can\'t find an answer. I\'m hoping someone can help me here!\n\nI\'m relatively new to modding with IntelliJ and Fabric, so I\'ve been following a tutorial series on YT. Everything works fine for that person, but for me, I\'ve got this error happening when I try to run MC via IntelliJ:\n```\n[Render thread/ERROR] (Minecraft) Unhandled game exception\n java.lang.IllegalStateException: Some intrusive holders were not added to registry: [Reference{null=air}]\n    at net.minecraft.util.registry.SimpleRegistry.freeze(SimpleRegistry.java:341) ~[minecraft-project-@-merged-named.jar:?]\n    at net.minecraft.util.registry.Registry.freezeRegistries(Registry.java:377) ~[minecraft-project-@-merged-named.jar:?]\n    at net.minecraft.client.MinecraftClient.handler$zga000$onStart(MinecraftClient.java:4176) ~[minecraft-project-@-merged-named.jar:?]\n    at net.minecraft.client.MinecraftClient.run(MinecraftClient.java:707) ~[minecraft-project-@-merged-named.jar:?]\n    at net.minecraft.client.main.Main.main(Main.java:214) [minecraft-project-@-merged-named.jar:?]\n    at net.fabricmc.loader.impl.game.minecraft.MinecraftGameProvider.launch(MinecraftGameProvider.java:460) [fabric-loader-0.14.6.jar:?]\n    at net.fabricmc.loader.impl.launch.knot.Knot.launch(Knot.java:74) [fabric-loader-0.14.6.jar:?]\n    at net.fabricmc.loader.impl.launch.knot.KnotClient.main(KnotClient.java:23) [fabric-loader-0.14.6.jar:?]\n    at net.fabricmc.devlaunchinjector.Main.main(Main.java:86) [dev-launch-injector-0.2.1+build.8.jar:?]\n```',0,1,10,'question','2023-02-17 13:06:18','2023-03-15 14:07:22',0),
(20,9,'Sum of Fibonacci Sequence off by a value of 1','I have a code to calculate the sum of all even numbers of the Fibonacci Sequence less than 4,000,000.\n```\n/*\n  Through the use of Binet\'s formula for the Fibonacci Sequence and the fact\n  that every third number of the sequence is an even number.\n*/\n\nimport java.lang.Math.*;\n\npublic class Optimised002 {\n  public static void main(String[] args) {\n    long sum = 0;\n    for (int i = 0; i < 4_000_000; i += 3) {\n      long number = binetsFormula(i);\n      if (number < 4_000_000L) {\n        sum += number;\n      }\n    }\n    System.out.println(sum);\n  }\n\n  public static float sqrt5 = 2.2360679775f;\n  public static float goldenRatio = 1.61803398875f;\n  public static float reciprocalGoldenRaio = -0.61803398875f;\n\n  public static long binetsFormula(int nth) {\n    return Math.round((Math.pow(goldenRatio, nth) - Math.pow(reciprocalGoldenRaio, nth)) / sqrt5);\n  }\n}\n```\n\nThe correct answer that I had obtained through bruteforce previously is 4613732, for this method I am obtaining the sum of 4613733: off by a value of 1. Maybe its because of sqrt5 or goldenRatio not being precise enough or some computers being bad at maths sort of thing: I have no idea why. Insights are greatly appreciated.',6,1,1,'question','2023-02-22 11:08:02','2023-03-13 08:20:59',0),
(21,1,'Using Minecraft types inside of an enumBuilder','I\'m currently trying to add an enum to net.minecraft.class_189 (Advancement Frames) and currently am doing this:\n```\nvar remapper = FabricLoader.getInstance().getMappingResolver();\nString advancementFrame = remapper.mapClassName(\"intermediary\", \"net.minecraft.class_189\");\n\nClassTinkerers.enumBuilder(advancementFrame, String.class, Integer.class, Formatting.class).addEnum(\"OPTIONAL\", \"optional\", 52, Formatting.BLUE).build();\n```\nFabric-ASM, however, doesn\'t like that I\'m referring to a Minecraft class in `enumBuilder()`, said class I\'m referencing is `net.minecraft.class_124`, an enum that holds all the different formatting types.\n\nI\'m wondering if there\'s a way to reference the type in `net.minecraft.class_124` in `enumBuilder()` without it causing an error.',0,1,1,'question','2023-03-06 08:42:03','2023-03-15 14:07:22',0);
/*!40000 ALTER TABLE `table_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_post_answer`
--

DROP TABLE IF EXISTS `table_post_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table_post_answer` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) NOT NULL,
  `comment_id` bigint(20) NOT NULL,
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `table_post_answer_pk` (`post_id`),
  UNIQUE KEY `table_post_answer_pk2` (`comment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_post_answer`
--

LOCK TABLES `table_post_answer` WRITE;
/*!40000 ALTER TABLE `table_post_answer` DISABLE KEYS */;
INSERT INTO `table_post_answer` VALUES
(1,2,2,'2023-02-15 12:25:47'),
(2,5,4,'2023-02-15 16:16:13'),
(3,7,5,'2023-02-15 19:52:01'),
(4,19,6,'2023-02-17 13:06:56'),
(5,20,7,'2023-02-22 11:23:32'),
(6,21,8,'2023-03-06 08:55:38');
/*!40000 ALTER TABLE `table_post_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_post_tag`
--

DROP TABLE IF EXISTS `table_post_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table_post_tag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_post_tag`
--

LOCK TABLES `table_post_tag` WRITE;
/*!40000 ALTER TABLE `table_post_tag` DISABLE KEYS */;
INSERT INTO `table_post_tag` VALUES
(1,2,1),
(2,2,6),
(3,3,1),
(4,5,1),
(5,6,1),
(6,6,4),
(7,6,5),
(8,7,1),
(9,7,6),
(10,8,1),
(11,8,6),
(12,9,1),
(13,9,6),
(14,10,1),
(15,10,6),
(16,11,1),
(17,11,6),
(18,12,1),
(19,12,6),
(20,13,1),
(21,13,6),
(22,14,1),
(23,14,6),
(24,15,1),
(25,15,6),
(26,16,1),
(27,16,6),
(28,17,1),
(29,17,6),
(30,18,7),
(31,19,1),
(32,19,6),
(33,20,1),
(34,20,9),
(35,20,10),
(36,21,1),
(37,21,6);
/*!40000 ALTER TABLE `table_post_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_role`
--

DROP TABLE IF EXISTS `table_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(8) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_role`
--

LOCK TABLES `table_role` WRITE;
/*!40000 ALTER TABLE `table_role` DISABLE KEYS */;
INSERT INTO `table_role` VALUES
(1,'owner'),
(2,'admin'),
(3,'user'),
(4,'banned');
/*!40000 ALTER TABLE `table_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_role_permission`
--

DROP TABLE IF EXISTS `table_role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table_role_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_role_permission`
--

LOCK TABLES `table_role_permission` WRITE;
/*!40000 ALTER TABLE `table_role_permission` DISABLE KEYS */;
INSERT INTO `table_role_permission` VALUES
(1,1,1),
(2,1,2),
(3,1,3),
(4,1,4),
(5,1,5),
(6,1,6),
(7,1,7),
(8,2,1),
(9,2,2),
(10,2,3),
(11,2,4),
(12,2,5),
(13,2,6),
(14,2,7),
(15,3,1),
(16,3,2);
/*!40000 ALTER TABLE `table_role_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_tag`
--

DROP TABLE IF EXISTS `table_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `name` varchar(18) NOT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `invalid` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `table_tag_pk` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_tag`
--

LOCK TABLES `table_tag` WRITE;
/*!40000 ALTER TABLE `table_tag` DISABLE KEYS */;
INSERT INTO `table_tag` VALUES
(1,2,'Java','2023-02-13 09:59:36','2023-02-13 09:59:36',0),
(2,2,'C#','2023-02-13 09:59:41','2023-02-13 09:59:41',0),
(3,2,'Kotlin','2023-02-13 09:59:45','2023-02-13 09:59:45',0),
(4,2,'json','2023-02-13 13:14:41','2023-02-13 13:14:41',0),
(5,2,'SpringBoot','2023-02-13 13:14:48','2023-02-13 13:14:48',0),
(6,2,'Fabric','2023-02-15 19:00:06','2023-02-15 19:00:06',0),
(7,1,'markdown','2023-02-15 20:49:53','2023-02-15 20:49:53',0),
(8,1,'Spring','2023-02-16 12:51:14','2023-02-16 12:51:14',0),
(9,9,'Math','2023-02-22 11:07:12','2023-02-22 11:07:12',0),
(10,9,'fibonacci','2023-02-22 11:07:20','2023-02-22 11:07:20',0),
(11,1,'Fabirc','2023-03-03 09:04:16','2023-03-03 09:04:16',0);
/*!40000 ALTER TABLE `table_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_user`
--

DROP TABLE IF EXISTS `table_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(18) NOT NULL,
  `password` varchar(32) NOT NULL,
  `create_time` datetime NOT NULL,
  `update_time` datetime NOT NULL,
  `invalid` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `table_user_pk` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_user`
--

LOCK TABLES `table_user` WRITE;
/*!40000 ALTER TABLE `table_user` DISABLE KEYS */;
INSERT INTO `table_user` VALUES
(1,'Enaium','608231f12a6d311fce5d0af010414d4b','2023-02-11 11:52:42','2023-02-11 11:52:42',0),
(2,'123','608231f12a6d311fce5d0af010414d4b','2023-02-12 19:19:40','2023-02-12 19:19:40',0),
(9,'e8cabea3b792d9c4','1e742150b4f5aac218ed4e4295ed9c5d','2023-02-21 11:43:17','2023-02-21 11:43:17',0);
/*!40000 ALTER TABLE `table_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_user_info`
--

DROP TABLE IF EXISTS `table_user_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table_user_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `nickname` varchar(50) NOT NULL,
  `description` varchar(50) DEFAULT NULL,
  `avatar` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `table_user_info_pk` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_user_info`
--

LOCK TABLES `table_user_info` WRITE;
/*!40000 ALTER TABLE `table_user_info` DISABLE KEYS */;
INSERT INTO `table_user_info` VALUES
(1,1,'ROOT','ROOOOOOOOOOOOT',NULL),
(4,9,'Enaium',NULL,'https://foruda.gitee.com/avatar/1676985719805227372/1719034_enaium_1590506585.png');
/*!40000 ALTER TABLE `table_user_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_user_role`
--

DROP TABLE IF EXISTS `table_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `table_user_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `role_id` int(11) NOT NULL DEFAULT 3,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_user_role`
--

LOCK TABLES `table_user_role` WRITE;
/*!40000 ALTER TABLE `table_user_role` DISABLE KEYS */;
INSERT INTO `table_user_role` VALUES
(1,1,1),
(2,2,3),
(3,3,3);
/*!40000 ALTER TABLE `table_user_role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-03-15 14:09:10
