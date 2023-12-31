CREATE TABLE industry.friends -- UNNEST
(
    user_id        NVARCHAR(20) NOT NULL, -- 유저 아이디 (FK)
    friend_doll_id NVARCHAR(255) NOT NULL, -- 친구 doll_id

    CONSTRAINT PK_friends
        PRIMARY KEY (user_id, friend_doll_id),
    
    CONSTRAINT FK_friends
        FOREIGN KEY (user_id) REFERENCES industry.users(user_id)
        ON DELETE CASCADE
);
