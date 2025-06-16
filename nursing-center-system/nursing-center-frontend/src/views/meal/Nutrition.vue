<template>
  <div class="nutrition">    <div class="page-header">
      <h2>营养评估</h2>
      <el-button type="primary" @click="handleAdd">
        <el-icon><Plus /></el-icon>
        新增评估
      </el-button>
    </div>
    
    <el-card>
      <el-table :data="nutritionList" v-loading="loading" stripe>
        <el-table-column prop="customerName" label="客户姓名" />
        <el-table-column prop="assessmentDate" label="评估日期" />
        <el-table-column prop="height" label="身高(cm)" />
        <el-table-column prop="weight" label="体重(kg)" />
        <el-table-column prop="bmi" label="BMI">
          <template #default="{ row }">
            {{ row.bmi?.toFixed(1) || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="nutritionStatus" label="营养状况">
          <template #default="{ row }">
            <el-tag :type="getNutritionType(row.nutritionStatus)">
              {{ formatNutritionStatus(row.nutritionStatus) }}
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
          @size-change="fetchNutritionList"
          @current-change="fetchNutritionList"
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
import type { NutritionAssessment } from '@/api/meal'

const router = useRouter()
const loading = ref(false)
const nutritionList = ref<NutritionAssessment[]>([])

const pagination = reactive({
  page: 1,
  size: 10,
  total: 0
})

// 获取营养评估列表
const fetchNutritionList = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.page - 1,
      size: pagination.size
    }
      const response = await mealApi.getNutritionAssessments(params)
    nutritionList.value = response.data?.content || response.data?.records || []
    pagination.total = response.data?.totalElements || response.data?.total || 0
  } catch (error) {
    console.error('获取营养评估失败:', error)
    ElMessage.error('获取营养评估失败')
  } finally {
    loading.value = false
  }
}

// 新增评估
const handleAdd = () => {
  router.push('/meal/nutrition/add')
}

// 查看评估
const handleView = (row: NutritionAssessment) => {
  router.push(`/meal/nutrition/detail/${row.id}`)
}

// 编辑评估
const handleEdit = (row: NutritionAssessment) => {
  router.push(`/meal/nutrition/edit/${row.id}`)
}

// 删除评估
const handleDelete = async (row: NutritionAssessment) => {
  try {
    await ElMessageBox.confirm(`确认删除客户 ${row.customerName} 的营养评估记录吗？`, '确认删除', {
      type: 'warning'
    })
    
    await mealApi.deleteNutritionAssessment(row.id)
    ElMessage.success('删除成功')
    fetchNutritionList()
  } catch (error: any) {
    if (error.action !== 'cancel') {
      console.error('删除营养评估失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

// 获取营养状况标签类型
const getNutritionType = (status: string) => {
  const typeMap: Record<string, string> = {
    'NORMAL': 'success',
    'UNDERWEIGHT': 'warning',
    'OVERWEIGHT': 'warning',
    'MALNUTRITION': 'danger'
  }
  return typeMap[status] || 'info'
}

// 格式化营养状况显示
const formatNutritionStatus = (status: string) => {
  const statusMap: Record<string, string> = {
    'NORMAL': '正常',
    'UNDERWEIGHT': '偏瘦',
    'OVERWEIGHT': '偏胖',
    'MALNUTRITION': '营养不良'
  }
  return statusMap[status] || status
}

onMounted(() => {
  fetchNutritionList()
})
</script>

<style scoped>
.nutrition {
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
