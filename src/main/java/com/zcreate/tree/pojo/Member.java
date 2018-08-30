package com.zcreate.tree.pojo;

import java.io.Serializable;

public class Member implements Serializable {
    private Integer memberId;
    private String memberNo;
    private String realName;
    private String idCard;
    private String phone;
    private String memberInfo;
    private String parentNo;
    private Integer level;
    private Integer childTotal;
    private Integer childDepth;
    private Integer directCount;

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getMemberNo() {
        return memberNo;
    }

    public void setMemberNo(String memberNo) {
        this.memberNo = memberNo;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getMemberInfo() {
        return memberInfo;
    }

    public void setMemberInfo(String memberInfo) {
        this.memberInfo = memberInfo;
    }

    public String getParentNo() {
        return parentNo;
    }

    public void setParentNo(String parentNo) {
        this.parentNo = parentNo;
    }

    public Integer getLevel() {
        return level;
    }

    public void setLevel(Integer level) {
        this.level = level;
    }

    public Integer getChildTotal() {
        return childTotal;
    }

    public void setChildTotal(Integer childTotal) {
        this.childTotal = childTotal;
    }

    public Integer getChildDepth() {
        return childDepth;
    }

    public void setChildDepth(Integer childDepth) {
        this.childDepth = childDepth;
    }

    public Integer getDirectCount() {
        return directCount;
    }

    public void setDirectCount(Integer directCount) {
        this.directCount = directCount;
    }
}
