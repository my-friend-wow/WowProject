CREATE TABLE industry.items -- UNNEST
(
    user_id    NVARCHAR(20) NOT NULL, -- 유저 아이디 (FK)
    item_id    NVARCHAR(255) NOT NULL, -- 아이템 아이디
    item_name  NVARCHAR(255) NOT NULL -- 아이템 이름
);

ALTER TABLE industry.items
ADD CONSTRAINT FK_items
FOREIGN KEY (user_id) REFERENCES industry.users(user_id)
ON DELETE CASCADE;
