<template>
  <el-container class="layout-container">
    <!-- 侧边栏 -->
    <el-aside :width="isCollapse ? '64px' : '200px'" class="sidebar">
      <div class="logo">
        <span v-if="!isCollapse">东软颐养中心</span>
        <span v-else>东软</span>
      </div>
        <el-menu
        :default-active="activeMenu"
        :collapse="isCollapse"
        :unique-opened="true"
        router
        class="sidebar-menu"
      >
        <el-menu-item index="/">
          <el-icon><House /></el-icon>
          <span>首页概览</span>
        </el-menu-item>        <!-- 客户管理 -->
        <el-sub-menu index="customer">          <template #title>
            <el-icon><User /></el-icon>
            <span>客户管理</span>
          </template>
          <el-menu-item index="/customer/list">客户列表</el-menu-item>
          <el-menu-item index="/customer/checkin">入住登记</el-menu-item>
          <el-menu-item index="/customer/checkout">退住登记</el-menu-item>
          <el-menu-item index="/customer/outing">外出登记</el-menu-item>
          <el-menu-item index="/customer/return">回院登记</el-menu-item>

        </el-sub-menu>        <!-- 床位管理 -->
        <el-sub-menu index="bed">
          <template #title>
            <el-icon><Grid /></el-icon>
            <span>床位管理</span>
          </template>
          <el-menu-item index="/bed/diagram">床位示意图</el-menu-item>
          <el-menu-item index="/bed/usage">床位使用管理</el-menu-item>
        </el-sub-menu>
          <!-- 护理管理 -->
        <el-sub-menu index="nursing">
          <template #title>
            <el-icon><Monitor /></el-icon>
            <span>护理管理</span>
          </template>
          <el-menu-item index="/nursing/level">护理级别管理</el-menu-item>
          <el-menu-item index="/nursing/item">护理项目管理</el-menu-item>
          <el-menu-item index="/nursing/customer-care">客户护理设置</el-menu-item>
          <el-menu-item index="/nursing/record">护理记录管理</el-menu-item>
        </el-sub-menu>
          <!-- 健康管家 -->
        <el-sub-menu index="health-manager" v-if="hasRole(['ADMIN'])">
          <template #title>
            <el-icon><UserFilled /></el-icon>
            <span>健康管家</span>
          </template>
          <el-menu-item index="/health-manager/assign">设置服务对象</el-menu-item>
          <el-menu-item index="/health-manager/monitor">服务关注</el-menu-item>
        </el-sub-menu>

        <!-- 膳食管理 -->
        <el-sub-menu index="meal">
          <template #title>
            <el-icon><Dish /></el-icon>
            <span>膳食管理</span>
          </template>
          <el-menu-item index="/meal/plan">膳食计划</el-menu-item>
          <el-menu-item index="/meal/nutrition">营养评估</el-menu-item>
          <el-menu-item index="/meal/config">客户配餐</el-menu-item>
        </el-sub-menu>

        <!-- 系统管理 -->
        <el-sub-menu index="system" v-if="hasRole(['ADMIN'])">
          <template #title>
            <el-icon><Setting /></el-icon>
            <span>系统管理</span>
          </template>
          <el-menu-item index="/system/user">用户管理</el-menu-item>
          <el-menu-item index="/system/role">角色管理</el-menu-item>
          <el-menu-item index="/system/logs">系统日志</el-menu-item>
        </el-sub-menu>
      </el-menu>
    </el-aside>

    <!-- 主要内容区域 -->
    <el-container>
      <!-- 顶部导航 -->
      <el-header class="header">
        <div class="header-left">
          <el-button
            :icon="isCollapse ? Expand : Fold"
            @click="toggleCollapse"
            text
          />
        </div>

        <div class="header-right">
          <el-dropdown @command="handleCommand">
            <span class="user-info">
              <el-icon><User /></el-icon>
              {{ userStore.userInfo?.name || '用户' }}
              <el-icon><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">个人信息</el-dropdown-item>
                <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <!-- 主要内容 -->
      <el-main class="main-content">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  House,
  User,
  UserFilled,
  Grid,
  Monitor,
  Dish,
  Document,
  Setting,
  Fold,
  Expand,
  ArrowDown
} from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/user'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const isCollapse = ref(false)

const activeMenu = computed(() => route.path)

const toggleCollapse = () => {
  isCollapse.value = !isCollapse.value
}

const handleCommand = async (command: string) => {
  switch (command) {
    case 'profile':
      ElMessage.info('个人信息功能开发中...')
      break
    case 'logout':
      try {
        await ElMessageBox.confirm('确认退出登录吗？', '提示', {
          type: 'warning'
        })
        userStore.logout()
        router.push('/login')
        ElMessage.success('已退出登录')
      } catch {
        // 用户取消
      }
      break
  }
}

// 检查用户角色权限
const hasRole = (roles: string[]) => {
  const userRole = userStore.userInfo?.role
  return userRole && roles.includes(userRole)
}
</script>

<style scoped>
.layout-container {
  height: 100vh;
}

.sidebar {
  background-color: #304156;
  transition: width 0.3s;
}

.logo {
  height: 60px;
  line-height: 60px;
  text-align: center;
  font-size: 18px;
  font-weight: bold;
  color: white;
  background-color: #2b3a4b;
}

.sidebar-menu {
  border: none;
  background-color: #304156;
}

.sidebar-menu .el-menu-item {
  color: #bfcbd9;
}

.sidebar-menu .el-menu-item:hover {
  background-color: #263445;
  color: #fff;
}

.sidebar-menu .el-menu-item.is-active {
  background-color: #409eff;
  color: #fff;
}

.sidebar-menu .el-sub-menu__title {
  color: #bfcbd9;
}

.sidebar-menu .el-sub-menu__title:hover {
  background-color: #263445;
  color: #fff;
}

.header {
  background-color: #fff;
  border-bottom: 1px solid #e6e6e6;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
}

.header-left,
.header-right {
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  align-items: center;
  cursor: pointer;
  color: #333;
  padding: 0 10px;
}

.user-info:hover {
  color: #409eff;
}

.main-content {
  background-color: #f5f5f5;
  padding: 20px;
}
</style>
