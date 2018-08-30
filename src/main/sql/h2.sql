

-- ----------------------------
-- Table structure for member
-- ----------------------------
DROP TABLE IF EXISTS member;

CREATE TABLE member (
  member_id    int           auto_increment,
  member_no    varchar(20) NOT NULL,
  user_name    varchar(100),-- 用户名
  real_name    varchar(100),
  id_card      varchar(100), -- 身份证号码
  phone        varchar(100), -- 电话
  member_info  varchar(1023) DEFAULT NULL,
  parent_no    varchar(20)   DEFAULT NULL,
  level        int           DEFAULT 0, -- 当前层级
  child_total  int           DEFAULT 0, -- 所有下级数
  child_depth  int           DEFAULT 0, -- 下级深度
  direct_count int           DEFAULT 0, -- 直接下级数
  PRIMARY KEY (member_id)
)
  DEFAULT CHARSET = utf8;


create index ix_user_name
  on member (user_name);
create index ix_memberno
  on member (member_no);
create index ix_realname
  on member (real_name);
create index ix_idcard
  on member (id_card);
create index ix_phone
  on member (phone);
create index ix_parentno
  on member (parent_no);