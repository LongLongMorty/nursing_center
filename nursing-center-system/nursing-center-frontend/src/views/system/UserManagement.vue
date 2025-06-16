<template>
  <div class="user-management">
    <div class="page-header">
      <h2>用户管理</h2>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>
        新增用户
      </el-button>
    </div>
    
    <div class="search-section">
      <el-form :model="searchForm" inline>
        <el-form-item label="用户名">
          <el-input v-model="searchForm.username" placeholder="请输入用户名" clearable />
        </el-form-item>
        <el-form-item label="姓名">
          <el-input v-model="searchForm.name" placeholder="请输入姓名" clearable />
        </el-form-item>
        <el-form-item label="角色">
          <el-select v-model="searchForm.role" placeholder="请选择角色" clearable>
            <el-option label="管理员" value="ADMIN" />
            <el-option label="健康管家" value="HEALTH_MANAGER" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="启用" :value="1" />
            <el-option label="禁用" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
    
    <el-card>
      <el-table :data="userList" v-loading="loading" stripe>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="username" label="用户名" />
        <el-table-column prop="realName" label="姓名" />
        <el-table-column prop="phone" label="手机号" />
        <el-table-column prop="role" label="角色">
          <template #default="{ row }">
            <el-tag>{{ getRoleName(row.role) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态">
          <template #default="{ row }">
            <el-switch
              v-model="row.status"
              :active-value="1"
              :inactive-value="0"
              active-text="启用"
              inactive-text="禁用"
              @change="handleStatusChange(row)"
            />
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" />
        <el-table-column label="操作" width="300" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="handleView(row)">查看</el-button>
            <el-button size="small" type="primary" @click="handleEdit(row)">编辑</el-button>
            <el-button size="small" type="warning" @click="handleResetPassword(row)">重置密码</el-button>
            <el-button 
              size="small" 
              type="danger" 
              :disabled="row.username === 'admin'" 
              @click="handleDelete(row)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <div class="pagination">
        <el-pagination
          v-model:current-page="pagination.pageNum"
          v-model:page-size="pagination.pageSize"
          :total="pagination.total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 用户编辑对话框 -->
    <UserDialog
      v-model:visible="dialogVisible"
      :mode="dialogMode"
      :data="selectedUser"
      @success="handleDialogSuccess"
    />

    <!-- 密码重置对话框 -->
    <PasswordResetDialog
      v-model:visible="passwordDialogVisible"
      :user-id="selectedUserId"
      @success="handlePasswordResetSuccess"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import { systemApi } from '@/api'
import type { User, UserQueryDTO } from '@/api/system'
import UserDialog from './components/UserDialog.vue'
import PasswordResetDialog from './components/PasswordResetDialog.vue'

const loading = ref(false)
const userList = ref<User[]>([])
const dialogVisible = ref(false)
const dialogMode = ref<'add' | 'edit' | 'view'>('add')
const selectedUser = ref<User | null>(null)
const passwordDialogVisible = ref(false)
const selectedUserId = ref<number>(0)

const searchForm = reactive({
  username: '',
  name: '',
  role: '',
  status: undefined as number | undefined
})

const pagination = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})

// 获取用户列表
const fetchUserList = async () => {
  loading.value = true
  try {
    const params: UserQueryDTO = {
      pageNum: pagination.pageNum,
      pageSize: pagination.pageSize,
      username: searchForm.username || undefined,
      name: searchForm.name || undefined,
      role: searchForm.role || undefined,
      status: searchForm.status
    }
      const response = await systemApi.getUsers(params)
    userList.value = response.data?.records || []
    pagination.total = response.data?.total || 0
  } catch (error) {
    console.error('获取用户列表失败:', error)
    ElMessage.error('获取用户列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  pagination.pageNum = 1
  fetchUserList()
}

// 重置
const handleReset = () => {
  searchForm.username = ''
  searchForm.name = ''
  searchForm.role = ''
  searchForm.status = undefined
  handleSearch()
}

// 新增用户
const handleAdd = () => {
  selectedUser.value = null
  dialogMode.value = 'add'
  dialogVisible.value = true
}

// 查看用户
const handleView = (row: User) => {
  selectedUser.value = row
  dialogMode.value = 'view'
  dialogVisible.value = true
}

// 编辑用户
const handleEdit = (row: User) => {
  selectedUser.value = row
  dialogMode.value = 'edit'
  dialogVisible.value = true
}

// 删除用户
const handleDelete = async (row: User) => {
  try {
    await ElMessageBox.confirm(`确认删除用户 ${row.realName} 吗？`, '确认删除', {
      type: 'warning'
    })
    
    await systemApi.deleteUser(row.id)
    ElMessage.success('删除成功')
    fetchUserList()
  } catch (error: any) {
    if (error !== 'cancel') {
      console.error('删除用户失败:', error)
      ElMessage.error('删除用户失败')
    }
  }
}

// 重置密码
const handleResetPassword = (row: User) => {
  selectedUserId.value = row.id
  passwordDialogVisible.value = true
}

// 状态切换
const handleStatusChange = async (row: User) => {
  try {
    await systemApi.toggleUserStatus(row.id, row.status)
    ElMessage.success('状态更新成功')
  } catch (error) {
    console.error('更新状态失败:', error)
    ElMessage.error('状态更新失败')
    // 回滚状态
    row.status = row.status === 1 ? 0 : 1
  }
}

// 分页处理
const handleSizeChange = () => {
  pagination.pageNum = 1
  fetchUserList()
}

const handleCurrentChange = () => {
  fetchUserList()
}

// 对话框成功回调
const handleDialogSuccess = () => {
  dialogVisible.value = false
  fetchUserList()
}

// 密码重置成功回调
const handlePasswordResetSuccess = () => {
  passwordDialogVisible.value = false
  ElMessage.success('密码重置成功')
}

const getRoleName = (role: string) => {
  const roleMap: Record<string, string> = {
    'ADMIN': '管理员',
    'HEALTH_MANAGER': '健康管家'
  }
  return roleMap[role] || role
}

onMounted(() => {
  fetchUserList()
})
</script>

<style scoped>
.user-management {
  background: white;
  padding: 20px;
  border-radius: 8px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h2 {
  margin: 0;
  color: #333;
}

.search-section {
  margin-bottom: 20px;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 6px;
}

.pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
}
</style>
