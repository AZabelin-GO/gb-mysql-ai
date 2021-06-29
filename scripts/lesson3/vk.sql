-- MySQL Workbench Synchronization
-- Generated: 2021-06-22 22:49
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: v

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE TABLE IF NOT EXISTS `vk`.`user` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(245) NOT NULL,
  `phone` BIGINT(13) UNSIGNED NOT NULL,
  `password_hash` CHAR(65) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE NOW(),
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `phone_UNIQUE` (`phone` ASC) INVISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `vk`.`profile` (
  `user_id` INT(10) UNSIGNED NOT NULL,
  `firstname` VARCHAR(245) NOT NULL,
  `lastname` VARCHAR(245) NOT NULL,
  `gender` ENUM('m', 'f', 'x') NOT NULL,
  `birhday` DATE NOT NULL,
  `address` VARCHAR(245) NULL DEFAULT NULL,
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE NOW(),
  `photo_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `firstname_lastname_idx` (`lastname` ASC, `firstname` ASC) INVISIBLE,
  INDEX `media_idx` (`photo_id` ASC) VISIBLE,
  CONSTRAINT `fk_profile_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_profile_media1`
    FOREIGN KEY (`photo_id`)
    REFERENCES `vk`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `vk`.`message` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `from_user_id` INT(10) UNSIGNED NOT NULL,
  `to_user_id` INT(10) UNSIGNED NOT NULL,
  `text` TEXT NULL DEFAULT NULL,
  `media_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `read_at` DATETIME NULL DEFAULT NULL,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `from_user_idx` (`from_user_id` ASC) VISIBLE,
  INDEX `to_user_idx` (`to_user_id` ASC) VISIBLE,
  INDEX `media_idx` (`media_id` ASC) VISIBLE,
  CONSTRAINT `fk_mesage_profile1`
    FOREIGN KEY (`from_user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_mesage_profile2`
    FOREIGN KEY (`to_user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_message_media1`
    FOREIGN KEY (`media_id`)
    REFERENCES `vk`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `vk`.`friend_request` (
  `from_user_id` INT(10) UNSIGNED NOT NULL,
  `to_user_id` INT(10) UNSIGNED NOT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '-1 - отклонён; 0 - запрос; 1 - дружба',
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  `updated_at` DATETIME NULL DEFAULT NULL ON UPDATE NOW(),
  INDEX `from_user_idx` (`from_user_id` ASC) VISIBLE,
  INDEX `to_user_idx` (`to_user_id` ASC) VISIBLE,
  PRIMARY KEY (`from_user_id`, `to_user_id`),
  CONSTRAINT `fk_friend_request_profile1`
    FOREIGN KEY (`from_user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_friend_request_profile2`
    FOREIGN KEY (`to_user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `vk`.`community` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `admin_id` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `admin_idx` (`admin_id` ASC) VISIBLE,
  CONSTRAINT `fk_community_profile1`
    FOREIGN KEY (`admin_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `vk`.`user_community` (
  `community_id` INT(10) UNSIGNED NOT NULL,
  `user_id` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`community_id`, `user_id`),
  INDEX `user_idx` (`user_id` ASC) VISIBLE,
  INDEX `community_idx` (`community_id` ASC) VISIBLE,
  CONSTRAINT `fk_community_has_profile_community1`
    FOREIGN KEY (`community_id`)
    REFERENCES `vk`.`community` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_community_has_profile_profile1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `vk`.`post` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT(10) UNSIGNED NOT NULL,
  `community_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  `post_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  `text` TEXT NULL DEFAULT NULL,
  `media_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`id`),
  INDEX `user_idx` (`user_id` ASC) VISIBLE,
  INDEX `community_idx` (`community_id` ASC) VISIBLE,
  INDEX `post_idx` (`post_id` ASC) VISIBLE,
  INDEX `media_idx` (`media_id` ASC) VISIBLE,
  CONSTRAINT `fk_post_profile1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_community1`
    FOREIGN KEY (`community_id`)
    REFERENCES `vk`.`community` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `vk`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_post_media1`
    FOREIGN KEY (`media_id`)
    REFERENCES `vk`.`media` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `vk`.`media_type` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `vk`.`media` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `media_type_id` INT(10) UNSIGNED NOT NULL,
  `user_id` INT(10) UNSIGNED NOT NULL,
  `url` VARCHAR(45) NULL DEFAULT NULL,
  `blob` BLOB NULL DEFAULT NULL,
  `metadata` JSON NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`id`),
  INDEX `media_type_idx` (`media_type_id` ASC) VISIBLE,
  INDEX `user_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_media_media_type1`
    FOREIGN KEY (`media_type_id`)
    REFERENCES `vk`.`media_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_media_profile1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vk`.`profile` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
