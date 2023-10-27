CREATE TABLE industry.user_daily_activities -- 유저와 유저 Activity는 1:1
(
    user_id       NVARCHAR(20) NOT NULL PRIMARY KEY,
    today_walked  BIT NOT NULL DEFAULT 0, -- 오늘 걷기를 통해 코인을 교환했는가, 기본값은 0
    today_visited BIT NOT NULL DEFAULT 0 -- 오늘 방문을 통해 코인을 교환했는가, 기본값은 0
);

ALTER TABLE industry.user_daily_activities
ADD CONSTRAINT FK_user_daily_activities
FOREIGN KEY (user_id) REFERENCES industry.users(user_id)
ON DELETE CASCADE;
