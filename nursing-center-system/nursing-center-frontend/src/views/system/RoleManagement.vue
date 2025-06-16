<template>
  <div class="role-management">    <div class="page-header">
      <h2>角色管理</h2>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>
        新增角色
      </el-button>
    </div>
    
    <el-card>
      <el-table :data="roleList" v-loading="loading" stripe>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="角色名称" />
        <el-table-column prop="description" label="角色描述" show-overflow-tooltip />
        <el-table-column prop="permissions" label="权限数量">
          <template #default="{ row }">
            <el-tag type="info">{{ row.permissions?.length || 0 }}个权限</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" />
        <el-table-column label="操作" width="250" fixed="right">
          <template #default="{ row }">
            <el-button size="small" @click="handlePermissions(row)">权限配置</el-button>
            <el-button size="small" type="primary" @click="handleEdit(row)">编辑</el-button>
            <el-button size="small" type="danger" @click="handleDelete(row)">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <div class="pagination">
        <el-pagination
          v-model:current-page="pagination.page"
          v-model:page-size="pagination.size"
          :total="pagination.total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="fetchRoleList"
          @current-change="fetchRoleList"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import { systemApi } from '@/api'
import type { Role } from '@/api/system'

const router = useRouter()
const loading = ref(false)
const roleList = ref<Role[]>([])

const pagination = reactive({
  page: 1,
  size: 10,
  total: 0
})

// 获取角色列表
const fetchRoleList = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.page - 1,
      size: pagination.size
    }
      const response = await systemApi.getRoles(params)
    roleList.value = response.data?.content || response.data?.records || []
    pagination.total = response.data?.totalElements || response.data?.total || 0
  } catch (error) {
    console.error('获取角色列表失败:', error)
    ElMessage.error('获取角色列表失败')
  } finally {
    loading.value = false
  }
}

// 新增角色
const handleAdd = () => {
  router.push('/system/role/add')
}

// 权限配置
const handlePermissions = (row: Role) => {
  router.push(`/system/role/permissions/${row.id}`)
}

// 编辑角色
const handleEdit = (row: Role) => {
  router.push(`/system/role/edit/${row.id}`)
}

// 删除角色
const handleDelete = async (row: Role) => {
  try {
    await ElMessageBox.confirm(`确认删除角色 ${row.name} 吗？`, '确认删除', {
      type: 'warning'
    })
    
    await systemApi.deleteRole(row.id)
    ElMessage.success('删除成功')
    fetchRoleList()
  } catch (error: any) {
    if (error.action !== 'cancel') {
      console.error('删除角色失败:', error)
      ElMessage.error('删除角色失败')
    }
  }
}

onMounted(() => {
  fetchRoleList()
})
</script>

<style scoped>
.role-management {
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

.pagination {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
}
</style>
