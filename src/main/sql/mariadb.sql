SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for member
-- ----------------------------
DROP TABLE IF EXISTS member;

CREATE TABLE member (
  member_id    int           auto_increment,
  member_no    varchar(20) NOT NULL,
  real_name    varchar(100),
  id_card      varchar(100), -- 身份证号码
  phone        varchar(100), -- 电话
  member_info  varchar(1023) DEFAULT NULL,
  parent_id    varchar(20)   DEFAULT NULL,
  level        int(11)       DEFAULT 0, -- 当前层级
  child_total  int(11)       DEFAULT 0, -- 所有下级数
  child_depth  int(11)       DEFAULT 0, -- 下级深度
  direct_count int(11)       DEFAULT 0, -- 直接下级数
  PRIMARY KEY (member_id)
)
  ENGINE = MyISAM
  DEFAULT CHARSET = utf8;

alter table member
  add index ix_memberno (member_no);
alter table member
  add index ix_realname (real_name);
alter table member
  add index ix_idcard (idcard);
alter table member
  add index ix_phone(phone);
alter table member
  add index ix_parent_id (parent_id);