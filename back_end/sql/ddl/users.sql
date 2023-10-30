CREATE TABLE industry.users
(
    user_id     NVARCHAR(20) NOT NULL PRIMARY KEY, -- 유저 아이디 (PK)
    user_pw     NVARCHAR(20) NOT NULL, -- 유저 비밀번호
    token       NVARCHAR(255) NOT NULL, -- 본인 확인용 API 토큰
    coin_count  INT DEFAULT 0 NOT NULL, -- 유저 보유 코인 개수
    step_count  INT DEFAULT 0 NOT NULL, -- 유저 하루 걸음 수
    created_at  DATETIME NOT NULL -- 유저 가입 시기 기록용
);
