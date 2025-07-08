-- DELIMITER는 트리거와 같은 복합 구문 작성을 위해 문장의 끝을 임시로 변경하는 역할을 합니다.
DELIMITER $$

CREATE TRIGGER update_sales_frequency_trigger
-- salesOrder 테이블에 새로운 행이 삽입된 후에 트리거가 실행됩니다.
AFTER INSERT ON salesOrder
FOR EACH ROW
BEGIN
    -- 삽입된 item_no를 사용하여 itemList 테이블에서 item_group_no를 조회합니다.
    DECLARE v_item_group_no INT;
    SELECT item_group_no INTO v_item_group_no 
    FROM itemList 
    WHERE item_no = NEW.item_no;

    -- salesFrequency 테이블에 데이터를 삽입하거나, 중복 키가 있을 경우 frequency를 1 증가시킵니다.
    -- salesFrequency 테이블의 PK는 (client_no, item_no, item_group_no) 입니다.
    INSERT INTO salesFrequency (client_no, item_no, item_group_no, frequency, start_date, end_date)
    VALUES (NEW.client_no, NEW.item_no, v_item_group_no, 1, CURDATE(), ADDDATE(CURDATE(), 120))
    ON DUPLICATE KEY UPDATE
        frequency = frequency + 1;

END$$

-- DELIMITER를 다시 기본값(;)으로 복원합니다.
DELIMITER ;