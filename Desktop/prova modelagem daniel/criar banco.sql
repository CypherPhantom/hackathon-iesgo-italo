-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema prova1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `prova1` DEFAULT CHARACTER SET utf8 ;
USE `prova1` ;

-- -----------------------------------------------------
-- Table `prova1`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prova1`.`clientes` (
  `id_clientes` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `endereco` VARCHAR(45) NULL,
  `telefone` VARCHAR(45) NULL,
  PRIMARY KEY (`id_clientes`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `prova1`.`restaurntes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prova1`.`restaurntes` (
  `id_restaurntes` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_restaurntes`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `prova1`.`entregadores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prova1`.`entregadores` (
  `id_entregadores` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `cnh` VARCHAR(45) NULL,
  `modelo_veiculo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_entregadores`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `prova1`.`tipo_cardapio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prova1`.`tipo_cardapio` (
  `id_tipo_cardapio` INT NOT NULL AUTO_INCREMENT,
  `tipo_cardapio` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_tipo_cardapio`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `prova1`.`itens_cardapio`
-- -----------------------------------------------------
-- NOTA: A coluna 'preco' foi alterada de DECIMAL(3,3) para DECIMAL(5,2) para permitir o armazenamento de preços válidos (ex: 45.50).
CREATE TABLE IF NOT EXISTS `prova1`.`itens_cardapio` (
  `id_itens_cardapio` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `preco` DECIMAL(5,2) NOT NULL,
  `descricao` VARCHAR(45) NULL,
  `id_tipo_cardapio` INT NOT NULL,
  PRIMARY KEY (`id_itens_cardapio`),
  INDEX `fk_itens_tipo_idx` (`id_tipo_cardapio` ASC) VISIBLE,
  CONSTRAINT `fk_itens_tipo`
    FOREIGN KEY (`id_tipo_cardapio`)
    REFERENCES `prova1`.`tipo_cardapio` (`id_tipo_cardapio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `prova1`.`restaurante_cardapio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prova1`.`restaurante_cardapio` (
  `id_restaurante_cardapio` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `id_cardapio` INT NOT NULL,
  PRIMARY KEY (`id_restaurante_cardapio`),
  INDEX `fk_restaurante_cardapio_idx` (`id_restaurante` ASC) VISIBLE,
  INDEX `fk_cardapio_restaurante_idx` (`id_cardapio` ASC) VISIBLE,
  CONSTRAINT `fk_restaurante_cardapio`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `prova1`.`restaurntes` (`id_restaurntes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cardapio_restaurante`
    FOREIGN KEY (`id_cardapio`)
    REFERENCES `prova1`.`tipo_cardapio` (`id_tipo_cardapio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `prova1`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prova1`.`pedido` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NOT NULL,
  `id_restaurante` INT NOT NULL,
  `id_entregador` INT NOT NULL,
  `data_pedido` DATE NOT NULL,
  `status_entrega` VARCHAR(45) NOT NULL,
  `preco_entrega` DECIMAL(4,2) NOT NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `fk_cliente_pedido_idx` (`id_cliente` ASC) VISIBLE,
  INDEX `fk_pedido_restaurante_idx` (`id_restaurante` ASC) VISIBLE,
  INDEX `fk_pedido_entregador_idx` (`id_entregador` ASC) VISIBLE,
  CONSTRAINT `fk_cliente_pedido`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `prova1`.`clientes` (`id_clientes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `prova1`.`restaurntes` (`id_restaurntes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_entregador`
    FOREIGN KEY (`id_entregador`)
    REFERENCES `prova1`.`entregadores` (`id_entregadores`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `prova1`.`avaliacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prova1`.`avaliacao` (
  `id_avaliacao` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NOT NULL,
  `id_pedido` INT NOT NULL,
  `avaliacap_pedido` VARCHAR(45) NULL,
  `avaliacao_entrega` VARCHAR(45) NULL,
  PRIMARY KEY (`id_avaliacao`),
  INDEX `fk_avaliacao_cliente_idx` (`id_cliente` ASC) VISIBLE,
  INDEX `fk_avaliacao_pedido_idx` (`id_pedido` ASC) VISIBLE,
  CONSTRAINT `fk_avaliacao_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `prova1`.`clientes` (`id_clientes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_avaliacao_pedido`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `prova1`.`pedido` (`id_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

