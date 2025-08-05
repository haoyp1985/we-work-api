package com.wework.platform.common.query;

import lombok.Data;

import java.io.Serializable;

/**
 * 分页查询基础类
 * 
 * @author WeWork Platform
 * @since 2.0.0
 */
@Data
public class PageQuery implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 页码，从1开始
     */
    private Integer pageNum = 1;

    /**
     * 每页大小
     */
    private Integer pageSize = 10;

    /**
     * 排序字段
     */
    private String orderBy;

    /**
     * 是否升序排序
     */
    private Boolean isAsc = true;

    /**
     * 获取MyBatis-Plus的Page对象当前页码
     */
    public long getCurrent() {
        return pageNum;
    }

    /**
     * 获取MyBatis-Plus的Page对象每页大小
     */
    public long getSize() {
        return pageSize;
    }
}