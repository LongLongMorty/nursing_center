<template>
  <div class="meal-plan">    <div class="page-header">
      <h2>膳食计划</h2>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>
        新增计划
      </el-button>
    </div>
    
    <el-card>
      <el-table :data="mealPlanList" v-loading="loading" stripe>
        <el-table-column prop="customerName" label="客户姓名" />
        <el-table-column prop="planName" label="计划名称" />
        <el-table-column prop="mealType" label="餐食类型">
          <template #default="{ row }">
            {{ formatMealType(row.mealType) }}
          </template>
        </el-table-column>
        <el-table-column prop="startDate" label="开始日期" />
        <el-table-column prop="endDate" label="结束日期" />
        <el-table-column prop="status" label="状态">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">
              {{ formatStatus(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-button size="small" @click="handleView(row)">查看</el-button>
            <el-button size="small" type="primary" @click="handleEdit(row)">编辑</el-button>
            <el-button size="small" type="danger" @click="handleDelete(row)">删除</el-button>
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
          @size-change="fetchMealPlanList"
          @current-change="fetchMealPlanList"
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
import { mealApi } from '@/api'
import type { MealPlan } from '@/api/meal'

const router = useRouter()
const loading = ref(false)
const mealPlanList = ref<MealPlan[]>([])

const pagination = reactive({
  page: 1,
  size: 10,
  total: 0
})

// 获取膳食计划列表
const fetchMealPlanList = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.page - 1,
      size: pagination.size
    }
      const response = await mealApi.getPlans(params)
    mealPlanList.value = response.data?.content || response.data?.records || []
    pagination.total = response.data?.totalElements || response.data?.total || 0
  } catch (error) {
    console.error('获取膳食计划失败:', error)
    ElMessage.error('获取膳食计划失败')
  } finally {
    loading.value = false
  }
}

// 新增计划
const handleAdd = () => {
  router.push('/meal/plan/add')
}

// 查看计划
const handleView = (row: MealPlan) => {
  router.push(`/meal/plan/detail/${row.id}`)
}

// 编辑计划
const handleEdit = (row: MealPlan) => {
  router.push(`/meal/plan/edit/${row.id}`)
}

// 删除计划
const handleDelete = async (row: MealPlan) => {
  try {
    await ElMessageBox.confirm(`确认删除膳食计划 ${row.planName} 吗？`, '确认删除', {
      type: 'warning'
    })
    
    await mealApi.deletePlan(row.id)
    ElMessage.success('删除成功')
    fetchMealPlanList()
  } catch (error: any) {
    if (error.action !== 'cancel') {
      console.error('删除膳食计划失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

// 获取状态标签类型
const getStatusType = (status: string) => {
  const typeMap: Record<string, string> = {
    'ACTIVE': 'success',
    'COMPLETED': 'info',
    'PAUSED': 'warning',
    'CANCELLED': 'danger'
  }
  return typeMap[status] || 'info'
}

// 格式化状态显示
const formatStatus = (status: string) => {
  const statusMap: Record<string, string> = {
    'ACTIVE': '执行中',
    'COMPLETED': '已完成',
    'PAUSED': '已暂停',
    'CANCELLED': '已取消'
  }
  return statusMap[status] || status
}

// 格式化膳食类型
const formatMealType = (mealType: string) => {
  const typeMap: Record<string, string> = {
    'NORMAL': '普通餐',
    'LOW_SALT': '低盐餐',
    'LOW_SUGAR': '低糖餐',
    'SOFT': '软食',
    'LIQUID': '流食'
  }
  return typeMap[mealType] || mealType
}

onMounted(() => {
  fetchMealPlanList()
})
</script>

<style scoped>
.meal-plan {
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
