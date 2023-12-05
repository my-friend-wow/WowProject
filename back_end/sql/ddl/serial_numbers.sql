CREATE TABLE industry.serial_numbers -- 인형의 시리얼 넘버 모음을 미리 저장
(
    doll_id       NVARCHAR(255) NOT NULL PRIMARY KEY,
    is_active     BIT NOT NULL DEFAULT 0
);
