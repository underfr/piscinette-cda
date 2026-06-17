CREATE DATABASE IF NOT EXISTS plantes CHARSET utf8mb4;

USE plantes;

CREATE TABLE IF NOT EXISTS roles(
    id_role INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) NOT NULL UNIQUE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS users(
    id_users INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    firstname VARCHAR(50) NOT NULL,
    nickname VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    `password` VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_role INT,
    CONSTRAINT fk_users_roles FOREIGN KEY(id_role) REFERENCES roles(id_role)
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS friends(
    id_friend INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    id_user1 INT NOT NULL,
    id_user2 INT NOT NULL,
    status ENUM('pending','accepted','blocked') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_friendship(id_user1, id_user2),
    CONSTRAINT chk_friends_different CHECK (id_user1 != id_user2),
    CONSTRAINT chk_order CHECK (id_user1 < id_user2),
    CONSTRAINT fk_friends_user1 FOREIGN KEY(id_user1) REFERENCES users(id_users) ON DELETE CASCADE,
    CONSTRAINT fk_friends_user2 FOREIGN KEY(id_user2) REFERENCES users(id_users) ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS private_message(
    id_private_message INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `message` TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_sender INT NOT NULL,
    id_receiver INT NOT NULL,
    id_friend INT NOT NULL,
    CONSTRAINT chk_sender_receiver CHECK (id_sender != id_receiver),
    CONSTRAINT fk_pm_sender FOREIGN KEY(id_sender) REFERENCES users(id_users) ON DELETE CASCADE,
    CONSTRAINT fk_pm_receiver FOREIGN KEY(id_receiver) REFERENCES users(id_users) ON DELETE CASCADE,
    CONSTRAINT fk_pm_friend FOREIGN KEY(id_friend) REFERENCES friends(id_friend) ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS plants(
    id_plant INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    species VARCHAR(100) NOT NULL,
    buy_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `image` VARCHAR(255) NOT NULL,
    water_quantity DECIMAL(5, 2) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    id_user INT NOT NULL,
    CONSTRAINT fk_plants_user FOREIGN KEY(id_user) REFERENCES users(id_users) ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tracker(
    id_tracker INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    measure DECIMAL(5, 2) NOT NULL,
    tracker_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    watering VARCHAR(50) NOT NULL,
    id_plant INT NOT NULL,
    CONSTRAINT fk_tracker_plant FOREIGN KEY(id_plant) REFERENCES plants(id_plant)
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tracker_timeline(
    id_timeline INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    measure DECIMAL(5, 2) NOT NULL,
    tracker_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    watering VARCHAR(50) NOT NULL,
    id_plant INT NOT NULL,
    CONSTRAINT fk_tracker_plant FOREIGN KEY(id_plant) REFERENCES plants(id_plant)
)ENGINE=InnoDB;

DELIMITER $$

CREATE TRIGGER before_tracker_update
BEFORE INSERT ON tracker
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM tracker WHERE id_plant = NEW.id_plant) THEN
    
        INSERT INTO tracker_timeline (measure, tracker_date, watering, id_plant)
        SELECT measure, tracker_date, watering, id_plant
        FROM tracker
        WHERE id_plant = NEW.id_plant;
        
        DELETE FROM tracker WHERE id_plant = NEW.id_plant;
        
    END IF;
END$$

DELIMITER ;

CREATE TABLE IF NOT EXISTS care (
    id_care INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    care_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    height DECIMAL(5, 2) NOT NULL,
    repotting BOOLEAN DEFAULT 0,
    fertilization BOOLEAN DEFAULT 0,
    id_plant INT NOT NULL,
    CONSTRAINT fk_care_plant FOREIGN KEY(id_plant) REFERENCES plants(id_plant) ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS hints(
    id_hint INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) UNIQUE NOT NULL,
    `description` TEXT NOT NULL,
    link VARCHAR(255) NOT NULL,
    id_user INT NOT NULL,
    CONSTRAINT fk_hints_user FOREIGN KEY(id_user) REFERENCES users(id_users) ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS hints_plants(
    id_plant INT NOT NULL,
    id_hint INT NOT NULL,
    PRIMARY KEY(id_plant,id_hint),
    CONSTRAINT fk_hints_plants_plant FOREIGN KEY(id_plant) REFERENCES plants(id_plant) ON DELETE CASCADE,
    CONSTRAINT fk_hints_plants_hint FOREIGN KEY(id_hint) REFERENCES hints(id_hint) ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS forum_post(
    id_post INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(100) UNIQUE NOT NULL,
    `description` TEXT NOT NULL,
    img VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_user INT NOT NULL,
    CONSTRAINT fk_forum_post_user FOREIGN KEY(id_user) REFERENCES users(id_users) ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS forum_comment(
    id_comment INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    id_user INT NOT NULL,
    id_post INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_forum_comment_user FOREIGN KEY(id_user) REFERENCES users(id_users) ON DELETE CASCADE,
    CONSTRAINT fk_forum_comment_post FOREIGN KEY(id_post) REFERENCES forum_post(id_post) ON DELETE CASCADE
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS forum_review(
    id_review INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    rating DECIMAL(2, 1) NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_user INT NOT NULL,
    id_post INT NOT NULL,
    CONSTRAINT fk_review_user FOREIGN KEY(id_user) REFERENCES users(id_users) ON DELETE CASCADE,
    CONSTRAINT fk_review_post FOREIGN KEY(id_post) REFERENCES forum_post(id_post) ON DELETE CASCADE
)ENGINE=InnoDB;