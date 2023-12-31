CREATE TABLE industry.dolls  -- 유저와 인형은 1:1
(
    user_id     NVARCHAR(20) NOT NULL PRIMARY KEY, -- 유저 아이디 (FK)
    doll_name   NVARCHAR(6) NOT NULL, -- 인형 사용자지정 이름
    doll_id     NVARCHAR(255) NOT NULL, -- 인형 RFID id 고유번호

    CONSTRAINT FK_dolls_users
        FOREIGN KEY (user_id) REFERENCES industry.users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT FK_dolls_serial_numbers
        FOREIGN KEY (doll_id) REFERENCES industry.serial_numbers(doll_id)
);
