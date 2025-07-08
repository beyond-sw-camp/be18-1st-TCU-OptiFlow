CREATE TABLE `department` (
	`dept_no`			INTEGER			NOT NULL AUTO_INCREMENT,
	`dept_title`		VARCHAR(30)		NOT NULL,
	CONSTRAINT `PK_BOOKMARK` 	PRIMARY KEY (`dept_no`)
);

CREATE TABLE `employees` (
	`emp_no`				INTEGER			NOT NULL AUTO_INCREMENT,
	`dept_no`			INTEGER			NOT NULL,
	`emp_name`			VARCHAR(30)		NOT NULL,
	`email`				VARCHAR(60)		NOT NULL UNIQUE,
	`phone_number`		VARCHAR(15)		NOT NULL,
	`address`			VARCHAR(120)	NOT NULL,
	`ssn`					CHAR(64)			NOT NULL, -- SHA-256 해시 저장 기준
	`hire_date`			DATE				NOT NULL,
	`role`				TINYINT			NOT NULL,
	CONSTRAINT `PK_EMPLOYEES` PRIMARY KEY (`emp_no`),
	CONSTRAINT `FK_department_TO_employees_1` FOREIGN KEY (`dept_no`) 
	REFERENCES `department` (`dept_no`)
);


CREATE TABLE `client` (
	`client_no`			INTEGER 			NOT NULL AUTO_INCREMENT,
	`business_number`	VARCHAR(12)		NOT NULL UNIQUE,
	`company_name`		VARCHAR(60)		NOT NULL,
	`ceo_name`			VARCHAR(30)		NOT NULL,
	`ceo_phone`			VARCHAR(15)		NOT NULL,
	`client_phone`		VARCHAR(15)		NOT NULL,
	`client_name`		VARCHAR(30)		NOT NULL,
	`client_position`	VARCHAR(20)		NOT NULL,
	`client_address`	VARCHAR(120)	NOT NULL,
	CONSTRAINT `PK_CLIENT` PRIMARY KEY(`client_no`)
);

CREATE TABLE `itemGroup` (
	`item_group_no`	INTEGER			NOT NULL AUTO_INCREMENT,
	`item_group_name`	VARCHAR(30)		NOT NULL UNIQUE,
	CONSTRAINT `PK_ITEMGROUP` PRIMARY KEY (`item_group_no`)
);

CREATE TABLE `itemStatus` (
	`item_status_no`	INTEGER			NOT NULL AUTO_INCREMENT,
	`item_status`		VARCHAR(30)		NOT NULL,
	CONSTRAINT `PK_ITEMSTATUS` PRIMARY KEY (`item_status_no`)
);

CREATE TABLE `itemList` (
	`item_no`			INTEGER			NOT NULL AUTO_INCREMENT,
	`item_group_no`	INTEGER			NOT NULL,
	`item_status_no`	INTEGER			NOT NULL,
	`item_name`			VARCHAR(60)		NULL,
	`specification`	VARCHAR(100)	NULL,
	`unit`				VARCHAR(10)		NOT NULL,
	`created_at`		TIMESTAMP		NOT NULL DEFAULT NOW(),
	`updated_at`		TIMESTAMP		NOT NULL DEFAULT NOW(),
	CONSTRAINT `PK_ITEMLIST` PRIMARY KEY (`item_no`),
	
	CONSTRAINT `FK_itemGroup_TO_itemList_1` FOREIGN KEY (`item_group_no`)
	REFERENCES `itemGroup` (`item_group_no`),

	CONSTRAINT `FK_itemStatus_TO_itemList_1` FOREIGN KEY (`item_status_no`)
	REFERENCES `itemStatus` (`item_status_no`)
);

CREATE TABLE `requestOrder` (
	`ro_no`				INTEGER			NOT NULL AUTO_INCREMENT,
	`item_no`			INTEGER			NOT NULL,
	`client_no`			INTEGER			NOT NULL,
	`ro_date`			DATE				NOT NULL,
	`delivery_date`	DATE				NOT NULL,
	`req_amount`		INTEGER			NOT NULL,
	`unit_price`		DECIMAL(10, 2)	NOT NULL,
	`order_remark`		VARCHAR(100)	NULL,
	CONSTRAINT `PK_REQUESTORDER` PRIMARY KEY (`ro_no`),
	CONSTRAINT `FK_itemList_TO_requestOrder_1` FOREIGN KEY (`item_no`)
	REFERENCES `itemList` (`item_no`),

	CONSTRAINT `FK_client_TO_requestOrder_1` FOREIGN KEY (`client_no`)
	REFERENCES `client` (`client_no`)
);

CREATE TABLE `order` (
	`order_no`			INTEGER			NOT NULL AUTO_INCREMENT,
	`item_no`			INTEGER			NOT NULL,
	`client_no`			INTEGER			NOT NULL,
	`order_date`		DATE				NOT NULL,
	`delivery_date`	DATE				NOT NULL,
	`order_amount`		INTEGER			NOT NULL,
	`order_price`		DECIMAL(10, 2)	NULL,
	`order_remark`		VARCHAR(100)	NULL,
	CONSTRAINT `PK_ORDER` PRIMARY KEY (`order_no`),

	CONSTRAINT `FK_itemList_TO_order_1` FOREIGN KEY (`item_no`)
	REFERENCES `itemList` (`item_no`),

	CONSTRAINT `FK_client_TO_order_1` FOREIGN KEY (`client_no`)
	REFERENCES `client` (`client_no`)
);

CREATE TABLE `purchaseOrder` (
	`po_no`				INTEGER			NOT NULL AUTO_INCREMENT,
	`item_no`			INTEGER			NOT NULL,
	`emp_no`				INTEGER			NOT NULL,
	`client_no`			INTEGER			NOT NULL,
	`ro_no`				INTEGER			NOT NULL,
	`purchase_date`	DATE				NOT NULL,
	`purchase_amount`	INTEGER			NOT NULL,
	`unit_price`		DECIMAL(10, 2)	NOT NULL,
	`surtax`				INTEGER			NOT NULL,
	`price`				INTEGER			NOT NULL,
	`purchase_remark`	VARCHAR(100)	NULL,
	CONSTRAINT `PK_PURCHASEORDER` PRIMARY KEY (`po_no`),
	CONSTRAINT `FK_itemList_TO_purchaseOrder_1` FOREIGN KEY (`item_no`)
	REFERENCES `itemList` (	`item_no`),

	CONSTRAINT `FK_employees_TO_purchaseOrder_1` FOREIGN KEY (`emp_no`)
	REFERENCES `employees` (`emp_no`),

	CONSTRAINT `FK_client_TO_purchaseOrder_1` FOREIGN KEY (`client_no`)
	REFERENCES `client` (`client_no`),

	CONSTRAINT `FK_requestOrder_TO_purchaseOrder_1` FOREIGN KEY (`ro_no`)
	REFERENCES `requestOrder` (`ro_no`)
);

CREATE TABLE `bom` (
	`bom_no`				INTEGER			NOT NULL AUTO_INCREMENT,
	`parent_item_no`	INTEGER			NOT NULL,
	`child_item_no`	INTEGER			NOT NULL,
	`quantity`			INTEGER			NOT NULL,
	`unit`				VARCHAR(10)		NOT NULL,
	CONSTRAINT `PK_BOM` PRIMARY KEY (`bom_no`),

 	CONSTRAINT `FK_itemList_TO_bom_1` FOREIGN KEY (`parent_item_no`)
	REFERENCES `itemList` (`item_no`),

	CONSTRAINT `FK_itemList_TO_bom_2` FOREIGN KEY (`child_item_no`)
	REFERENCES `itemList` (`item_no`)
);

CREATE TABLE `similarWord` (
	`item_no`			INTEGER			NOT NULL,
	`similar_words`	VARCHAR(100)	NULL,
	CONSTRAINT `PK_SIMILARWORD` PRIMARY KEY (`item_no`),

	CONSTRAINT `FK_itemList_TO_similarWord_1` FOREIGN KEY (`item_no`)
	REFERENCES `itemList` (`item_no`)
);

CREATE TABLE `storage` (
	`storage_no`		INTEGER			NOT NULL AUTO_INCREMENT,
	`item_no`			INTEGER			NOT NULL,
	`storage_name`		VARCHAR(50)		NULL,
	`storage_div`		TINYINT			NOT NULL,
	CONSTRAINT `PK_STORAGE` PRIMARY KEY (`storage_no`),

	CONSTRAINT `FK_itemList_TO_storage_1` FOREIGN KEY (`item_no`)
	REFERENCES `itemList` (`item_no`)
);


CREATE TABLE `salesOrder` (
	`so_no`				INTEGER			NOT NULL AUTO_INCREMENT,
	`item_no`			INTEGER			NOT NULL,
	`emp_no`				INTEGER			NOT NULL,
	`client_no`			INTEGER			NOT NULL,
	`order_no`			INTEGER			NOT NULL,
	`sales_date`		DATE				NOT NULL,
	`sales_amount`		INTEGER			NOT NULL,
	`unit_price`		DECIMAL(10, 2)	NOT NULL,
	`surtax`				INTEGER			NOT NULL,
	`price`				INTEGER			NOT NULL,
	`sales_remark`		VARCHAR(100)	NULL DEFAULT '귀사의 무궁한 발전을 기원합니다.',
	`sale_status`		TINYINT			NOT NULL DEFAULT 0,
	CONSTRAINT `PK_SALESORDER` PRIMARY KEY (`so_no`),
	CONSTRAINT `FK_itemList_TO_salesOrder_1` FOREIGN KEY (`item_no`)
	REFERENCES `itemList` (`item_no`),

	CONSTRAINT `FK_employees_TO_salesOrder_1` FOREIGN KEY (`emp_no`)
	REFERENCES `employees` (`emp_no`),

	CONSTRAINT `FK_client_TO_salesOrder_1` FOREIGN KEY (`client_no`)
	REFERENCES `client` (`client_no`),

	CONSTRAINT `FK_order_TO_salesOrder_1` FOREIGN KEY (`order_no`)
	REFERENCES `order` (`order_no`)
);

CREATE TABLE `salesPrice` (
	`item_no`			INTEGER			NOT NULL,
	`client_no`			INTEGER			NOT NULL,
	`unit_price`		DECIMAL(10, 2)	NOT NULL,
	`status`				TINYINT			NOT NULL,
	CONSTRAINT `PK_SALESPRICE` PRIMARY KEY (`item_no`,	`client_no`),

	CONSTRAINT `FK_itemList_TO_salesPrice_1` FOREIGN KEY (`item_no`)
	REFERENCES `itemList` (`item_no`),

	CONSTRAINT `FK_client_TO_salesPrice_1` FOREIGN KEY (`client_no`)
	REFERENCES `client` (`client_no`)
);


CREATE TABLE `manager` (
	`manager_no`		INTEGER			NOT NULL AUTO_INCREMENT,
	`client_no`			INTEGER			NOT NULL,
	`emp_no`				INTEGER			NOT NULL,
	`manager_id`		VARCHAR(20)		NULL,
	`manager_password`CHAR(64)			NULL,
	`login_status`		TINYINT			NOT NULL,
	`login_type`		TINYINT			NULL,
	CONSTRAINT `PK_MANAGER` PRIMARY KEY (`manager_no`),

	CONSTRAINT `FK_client_TO_manager_1` FOREIGN KEY (`client_no`)
	REFERENCES `client` (`client_no`),

	CONSTRAINT `FK_employees_TO_manager_1` FOREIGN KEY (`emp_no`)
	REFERENCES `employees` (`emp_no`)
);

CREATE TABLE `bookmark` (
	`menu_no`			INTEGER			NOT NULL AUTO_INCREMENT,
	`manager_no`		INTEGER			NOT NULL,
	`item_no`			INTEGER			NOT NULL,
	CONSTRAINT `PK_BOOKMARK` PRIMARY KEY (`menu_no`),
	CONSTRAINT `FK_manager_TO_bookmark_1` FOREIGN KEY (`manager_no`)
	REFERENCES `manager` (`manager_no`),

	CONSTRAINT `FK_itemList_TO_bookmark_1` FOREIGN KEY (`item_no`)
	REFERENCES `itemList` (	`item_no`)
);

CREATE TABLE `salesFrequency` (
	`client_no`			INTEGER			NOT NULL,
	`item_no`			INTEGER			NOT NULL,
	`item_group_no`	INTEGER			NOT NULL,
	`frequency`			INTEGER			NOT NULL,
	`start_date`		DATE				NOT NULL DEFAULT CURDATE(),
	`end_date`			DATE				NOT NULL DEFAULT ADDDATE(CURDATE(), 120),

	CONSTRAINT `PK_SALESFREQUENCY` PRIMARY KEY (
	`client_no`,
	`item_no`,
	`item_group_no`
	),

	CONSTRAINT `FK_client_TO_salesFrequency_1` FOREIGN KEY (`client_no`)
	REFERENCES `client` (`client_no`),

	CONSTRAINT `FK_itemList_TO_salesFrequency_1` FOREIGN KEY (`item_no`)
	REFERENCES `itemList` (`item_no`),

	CONSTRAINT `FK_itemGroup_TO_salesFrequency_1` FOREIGN KEY (`item_group_no`)
	REFERENCES `itemGroup` (`item_group_no`)
);

CREATE TABLE `logCategory` (
	`log_category_no`	INTEGER			NOT NULL AUTO_INCREMENT,
	`log_name`			VARCHAR(30)		NULL,
	CONSTRAINT `PK_LOGCATEGORY` PRIMARY KEY (`log_category_no`)
);

CREATE TABLE `log` (
	`log_no`				INTEGER			NOT NULL AUTO_INCREMENT,
	`manager_no`		INTEGER			NOT NULL,
	`log_category_no`	INTEGER			NOT NULL,
	`created_at`		TIMESTAMP		NOT NULL DEFAULT NOW(),
	CONSTRAINT `PK_LOG` PRIMARY KEY (`log_no`),
	CONSTRAINT `FK_manager_TO_log_1` FOREIGN KEY (`manager_no`)
	REFERENCES `manager` (`manager_no`),

	CONSTRAINT `FK_logCategory_TO_log_1` FOREIGN KEY (`log_category_no`)
	REFERENCES `logCategory` (`log_category_no`)
);