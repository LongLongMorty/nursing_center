package com.nursing.center.controller;

/**
 * @BelongsProject: nursing-center-system
 * @BelongsPackage: com.nursing.center.controller
 * @Author: LongLongMorty
 * @CreateTime: 2025-05-31  17:51
 * @Description: TODO
 * @Version: 1.0
 */


import com.nursing.center.common.result.Result;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/dashboard")
@CrossOrigin(origins = "*")
public class DashboardController {

    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalCustomers", 120);
        stats.put("totalBeds", 150);
        stats.put("occupiedBeds", 118);
        stats.put("availableBeds", 32);
        stats.put("outingCustomers", 5);
        stats.put("pendingApplies", 3);
        stats.put("todayCheckIns", 2);
        stats.put("todayCheckOuts", 1);
        return Result.success(stats);
    }

    @GetMapping("/bed-occupancy-trend")
    public Result<List<Map<String, Object>>> getBedOccupancyTrend(
            @RequestParam(defaultValue = "30") int days) {
        List<Map<String, Object>> trend = new ArrayList<>();

        // 生成最近30天的模拟数据
        Calendar cal = Calendar.getInstance();
        for (int i = days - 1; i >= 0; i--) {
            cal.add(Calendar.DATE, -1);
            Map<String, Object> data = new HashMap<>();
            data.put("date", String.format("2024-%02d-%02d",
                    cal.get(Calendar.MONTH) + 1, cal.get(Calendar.DATE)));
            data.put("occupancy", 75 + (int)(Math.random() * 20)); // 75-95%占用率
            trend.add(data);
        }

        return Result.success(trend);
    }

    @GetMapping("/customer-age-distribution")
    public Result<List<Map<String, Object>>> getCustomerAgeDistribution() {
        List<Map<String, Object>> distribution = new ArrayList<>();
        distribution.add(createAgeGroup("60-70岁", 35));
        distribution.add(createAgeGroup("70-80岁", 45));
        distribution.add(createAgeGroup("80-90岁", 30));
        distribution.add(createAgeGroup("90岁以上", 10));
        return Result.success(distribution);
    }

    @GetMapping("/care-level-distribution")
    public Result<List<Map<String, Object>>> getCareLevelDistribution() {
        List<Map<String, Object>> distribution = new ArrayList<>();
        distribution.add(createCareLevel("一级护理", 25, "#ff6b6b"));
        distribution.add(createCareLevel("二级护理", 35, "#4ecdc4"));
        distribution.add(createCareLevel("三级护理", 40, "#45b7d1"));
        distribution.add(createCareLevel("特级护理", 20, "#96ceb4"));
        return Result.success(distribution);
    }

    @GetMapping("/recent-activities")
    public Result<List<Map<String, Object>>> getRecentActivities(
            @RequestParam(defaultValue = "10") int limit) {
        List<Map<String, Object>> activities = new ArrayList<>();

        activities.add(createActivity("入住", "张三完成入住手续，入住301房间", "2024-01-15 10:30:00"));
        activities.add(createActivity("退住", "李四提交退住申请", "2024-01-15 09:15:00"));
        activities.add(createActivity("护理", "王五完成二级护理服务", "2024-01-15 08:45:00"));
        activities.add(createActivity("膳食", "今日午餐安排：红烧肉、青菜汤", "2024-01-15 11:00:00"));
        activities.add(createActivity("体检", "赵六完成月度健康检查", "2024-01-15 07:30:00"));

        // 限制返回数量
        if (activities.size() > limit) {
            activities = activities.subList(0, limit);
        }

        return Result.success(activities);
    }

    private Map<String, Object> createAgeGroup(String ageGroup, int count) {
        Map<String, Object> group = new HashMap<>();
        group.put("ageGroup", ageGroup);
        group.put("count", count);
        return group;
    }

    private Map<String, Object> createCareLevel(String levelName, int count, String color) {
        Map<String, Object> level = new HashMap<>();
        level.put("levelName", levelName);
        level.put("count", count);
        level.put("color", color);
        return level;
    }

    private Map<String, Object> createActivity(String type, String content, String time) {
        Map<String, Object> activity = new HashMap<>();
        activity.put("type", type);
        activity.put("content", content);
        activity.put("time", time);
        return activity;
    }
}
