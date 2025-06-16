<template>
  <div class="service-monitor">
    <!-- 页面头部 -->
    <el-card class="page-header-card" shadow="never">
      <div class="page-header">
        <h2>服务关注</h2>
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>健康管家</el-breadcrumb-item>
          <el-breadcrumb-item>服务关注</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
    </el-card>

    <!-- 客户搜索和列表 -->
    <el-card class="customer-list-card" shadow="always">
      <template #header>
        <div class="card-header">
          <span>客户信息列表</span>
          <div class="search-area">
            <el-input
              v-model="customerSearchKeyword"
              placeholder="请输入客户姓名"
              style="width: 300px"
              clearable
              @input="handleCustomerSearch"
            >
              <template #prefix>
                <el-icon><Search /></el-icon>
              </template>
            </el-input>
          </div>
        </div>
      </template>

      <el-table
        :data="filteredCustomers"
        v-loading="customersLoading"
        stripe
        border
        @row-click="handleSelectCustomer"
        highlight-current-row
        :current-row-key="selectedCustomer?.id"
        row-key="id">
        <el-table-column prop="name" label="客户姓名" width="120" align="center" />
        <el-table-column prop="age" label="年龄" width="80" align="center" />
        <el-table-column prop="gender" label="性别" width="80" align="center" />
        <el-table-column prop="roomNumber" label="房间号" width="100" align="center" />
        <el-table-column prop="healthManager" label="健康管家" width="120" align="center" />
        <el-table-column prop="serviceCount" label="服务项目数" width="120" align="center">
          <template #default="{ row }">
            <el-tag :type="row.serviceCount > 0 ? 'success' : 'info'">
              {{ row.serviceCount }} 项
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="entryDate" label="入住时间" width="180" align="center" />
        <el-table-column label="操作" width="200" align="center">
          <template #default="{ row }">
            <el-button-group>
              <el-button
                size="small"
                type="primary"
                @click.stop="handleSelectCustomer(row)">
                查看服务
              </el-button>
              <el-button
                size="small"
                type="success"
                @click.stop="handleAddService(row)">
                购买服务
              </el-button>
            </el-button-group>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 客户服务详情 -->
    <div v-if="selectedCustomer" class="service-details">
      <el-card class="service-list-card" shadow="always">
        <template #header>
          <div class="card-header">
            <span>{{ selectedCustomer.name }} 的护理服务项目</span>
            <div class="header-actions">
              <el-button type="success" @click="handleAddService(selectedCustomer)">
                <el-icon><Plus /></el-icon>
                购买服务
              </el-button>
            </div>
          </div>
        </template>

        <el-table
          :data="customerServices"
          v-loading="servicesLoading"
          stripe
          border>
          <el-table-column prop="serviceName" label="服务项目" width="150" align="center" />
          <el-table-column prop="serviceType" label="服务类型" width="120" align="center" />
          <el-table-column prop="unitPrice" label="单价(元)" width="100" align="center">
            <template #default="{ row }">
              ¥{{ row.unitPrice?.toLocaleString() || '0' }}
            </template>
          </el-table-column>
          <el-table-column prop="quantity" label="剩余数量" width="120" align="center">
            <template #default="{ row }">
              <el-tag :type="getQuantityType(row.quantity)">
                {{ row.quantity }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="expiryDate" label="到期时间" width="180" align="center">
            <template #default="{ row }">
              <span :class="getExpiryClass(row.expiryDate)">
                {{ row.expiryDate }}
              </span>
            </template>
          </el-table-column>
          <el-table-column prop="status" label="状态" width="120" align="center">
            <template #default="{ row }">
              <el-tag :type="getStatusType(row.status)">
                {{ getStatusText(row.status) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="purchaseDate" label="购买时间" width="180" align="center" />
          <el-table-column label="操作" width="200" align="center">
            <template #default="{ row }">
              <el-button-group>
                <el-button
                  size="small"
                  type="primary"
                  :disabled="row.status === 'expired'"
                  @click="handleRenewService(row)">
                  续费
                </el-button>
                <el-button
                  size="small"
                  type="danger"
                  @click="handleRemoveService(row)">
                  移除
                </el-button>
              </el-button-group>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </div>

    <!-- 选择客户提示 -->
    <el-empty v-else description="请选择一个客户查看其服务项目" />    <!-- 购买服务对话框 -->
    <el-dialog
      v-model="purchaseDialogVisible"
      title="购买护理服务"
      width="1000px"
      :close-on-click-modal="false">

      <div class="purchase-content">
        <el-alert
          :title="`为客户 ${selectedCustomer?.name} 购买护理服务`"
          type="info"
          :closable="false"
          show-icon
          style="margin-bottom: 20px" />

        <!-- 护理项目列表 -->
        <div class="available-services">
          <h3>可选护理项目</h3>
          <div class="service-search">
            <el-input
              v-model="serviceSearchKeyword"
              placeholder="请输入护理项目名称"
              style="width: 300px"
              clearable
            >
              <template #prefix>
                <el-icon><Search /></el-icon>
              </template>
            </el-input>
          </div>          <el-table
          :data="filteredAvailableServices"
          v-loading="availableServicesLoading"
          stripe
          border
          max-height="300"
          @selection-change="handleServiceSelection">
          <el-table-column type="selection" width="55" />
          <el-table-column prop="serviceName" label="服务项目" width="120" />
          <el-table-column prop="serviceType" label="服务类型" width="100" />
          <el-table-column prop="unitPrice" label="单价(元)" width="90" align="center">
            <template #default="{ row }">
              ¥{{ row.unitPrice?.toLocaleString() || '0' }}
            </template>
          </el-table-column>
          <el-table-column prop="description" label="服务描述" min-width="200" show-overflow-tooltip />
        </el-table>
        </div>

        <!-- 已选服务配置 -->
        <div v-if="selectedServices.length > 0" class="selected-services">
          <h3>已选护理项目配置</h3>          <el-table :data="selectedServices" stripe border>
          <el-table-column prop="serviceName" label="服务项目" width="120" />
          <el-table-column prop="unitPrice" label="单价(元)" width="90" align="center">
            <template #default="{ row }">
              ¥{{ row.unitPrice?.toLocaleString() || '0' }}
            </template>
          </el-table-column>
          <el-table-column label="数量" width="120" align="center">
            <template #default="{ row, $index }">
              <el-input-number
                v-model="row.quantity"
                :min="1"
                :max="999"
                size="small"
                style="width: 100px" />
            </template>
          </el-table-column>
          <el-table-column label="到期时间" width="180" align="center">
            <template #default="{ row, $index }">
              <el-date-picker
                v-model="row.expiryDate"
                type="date"
                placeholder="选择到期时间"
                size="small"
                style="width: 160px"
                :disabled-date="disabledDate" />
            </template>
          </el-table-column>
          <el-table-column label="小计(元)" width="100" align="center">
            <template #default="{ row }">
              ¥{{ (row.unitPrice * row.quantity).toLocaleString() }}
            </template>
          </el-table-column>
          <el-table-column label="操作" width="80" align="center">
            <template #default="{ row, $index }">
              <el-button
                size="small"
                type="danger"
                @click="removeSelectedService($index)">
                删除
              </el-button>
            </template>
          </el-table-column>
        </el-table>

          <div class="total-amount">
            <el-tag type="warning" size="large">
              总金额: ¥{{ totalAmount.toLocaleString() }}
            </el-tag>
          </div>
        </div>
      </div>

      <template #footer>
        <span class="dialog-footer">
          <el-button @click="purchaseDialogVisible = false">取消</el-button>
          <el-button
            type="primary"
            @click="handleConfirmPurchase"
            :loading="purchaseSubmitting"
            :disabled="selectedServices.length === 0">
            确认购买
          </el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 续费对话框 -->
    <el-dialog
      v-model="renewDialogVisible"
      title="服务续费"
      width="500px"
      :close-on-click-modal="false">

      <el-form :model="renewForm" label-width="100px">
        <el-form-item label="服务项目">
          <el-input :value="currentService?.serviceName" disabled />
        </el-form-item>
        <el-form-item label="当前数量">
          <el-input :value="currentService?.quantity" disabled />
        </el-form-item>
        <el-form-item label="新增数量" required>
          <el-input-number
            v-model="renewForm.addQuantity"
            :min="1"
            :max="999"
            style="width: 100%" />
        </el-form-item>
        <el-form-item label="当前到期时间">
          <el-input :value="currentService?.expiryDate" disabled />
        </el-form-item>
        <el-form-item label="新到期时间" required>
          <el-date-picker
            v-model="renewForm.newExpiryDate"
            type="date"
            placeholder="选择新的到期时间"
            style="width: 100%"
            :disabled-date="disabledDate" />
        </el-form-item>
        <el-form-item label="续费金额">
          <el-tag type="warning" size="large">
            ¥{{ (renewForm.addQuantity * (currentService?.unitPrice || 0)).toLocaleString() }}
          </el-tag>
        </el-form-item>
      </el-form>

      <template #footer>
        <span class="dialog-footer">
          <el-button @click="renewDialogVisible = false">取消</el-button>
          <el-button
            type="primary"
            @click="handleConfirmRenew"
            :loading="renewSubmitting">
            确认续费
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Plus } from '@element-plus/icons-vue'

// 数据类型定义
interface Customer {
  id: number
  name: string
  age: number
  gender: string
  roomNumber: string
  healthManager: string
  serviceCount: number
  entryDate: string
}

interface ServiceItem {
  id: number
  serviceName: string
  serviceType: string
  unitPrice: number
  quantity: number
  expiryDate: string
  status: 'normal' | 'low_quantity' | 'expired' | 'overdue'
  purchaseDate: string
  description?: string
}

interface AvailableService {
  id: number
  serviceName: string
  serviceType: string
  unitPrice: number
  description: string
}

interface SelectedService extends AvailableService {
  quantity: number
  expiryDate: string
}

// 响应式数据
const customersLoading = ref(false)
const servicesLoading = ref(false)
const availableServicesLoading = ref(false)
const purchaseSubmitting = ref(false)
const renewSubmitting = ref(false)

const customerSearchKeyword = ref('')
const serviceSearchKeyword = ref('')

const selectedCustomer = ref<Customer | null>(null)
const customerServices = ref<ServiceItem[]>([])

const purchaseDialogVisible = ref(false)
const renewDialogVisible = ref(false)

const selectedServices = ref<SelectedService[]>([])
const currentService = ref<ServiceItem | null>(null)

// 续费表单
const renewForm = reactive({
  addQuantity: 1,
  newExpiryDate: ''
})

// 模拟数据
const customers = ref<Customer[]>([
  {
    id: 1,
    name: '张大爷',
    age: 75,
    gender: '男',
    roomNumber: 'A101',
    healthManager: '张小华',
    serviceCount: 3,
    entryDate: '2024-05-15'
  },
  {
    id: 2,
    name: '李奶奶',
    age: 68,
    gender: '女',
    roomNumber: 'B205',
    healthManager: '李美丽',
    serviceCount: 2,
    entryDate: '2024-05-20'
  },
  {
    id: 3,
    name: '王叔叔',
    age: 72,
    gender: '男',
    roomNumber: 'C301',
    healthManager: '王强',
    serviceCount: 4,
    entryDate: '2024-06-01'
  },
  {
    id: 4,
    name: '赵阿姨',
    age: 70,
    gender: '女',
    roomNumber: 'A203',
    healthManager: '张小华',
    serviceCount: 0,
    entryDate: '2024-06-05'
  }
])

const availableServices = ref<AvailableService[]>([
  {
    id: 1,
    serviceName: '基础护理',
    serviceType: '日常护理',
    unitPrice: 50,
    description: '包括洗漱、翻身、更换床单等基础护理服务'
  },
  {
    id: 2,
    serviceName: '健康监测',
    serviceType: '医疗护理',
    unitPrice: 80,
    description: '定期测量血压、心率、体温等生命体征'
  },
  {
    id: 3,
    serviceName: '康复训练',
    serviceType: '康复护理',
    unitPrice: 120,
    description: '专业的康复训练指导和协助'
  },
  {
    id: 4,
    serviceName: '心理疏导',
    serviceType: '心理护理',
    unitPrice: 100,
    description: '专业心理师提供心理健康咨询和疏导'
  },
  {
    id: 5,
    serviceName: '营养配餐',
    serviceType: '生活护理',
    unitPrice: 60,
    description: '根据健康状况制定个性化营养餐'
  }
])

// 模拟客户服务数据
const customerServiceData = reactive<Record<number, ServiceItem[]>>({
  1: [
    {
      id: 101,
      serviceName: '基础护理',
      serviceType: '日常护理',
      unitPrice: 50,
      quantity: 15,
      expiryDate: '2024-07-15',
      status: 'normal',
      purchaseDate: '2024-05-15'
    },
    {
      id: 102,
      serviceName: '健康监测',
      serviceType: '医疗护理',
      unitPrice: 80,
      quantity: 3,
      expiryDate: '2024-06-30',
      status: 'low_quantity',
      purchaseDate: '2024-05-20'
    },
    {
      id: 103,
      serviceName: '康复训练',
      serviceType: '康复护理',
      unitPrice: 120,
      quantity: 0,
      expiryDate: '2024-06-10',
      status: 'expired',
      purchaseDate: '2024-05-10'
    }
  ],
  2: [
    {
      id: 201,
      serviceName: '基础护理',
      serviceType: '日常护理',
      unitPrice: 50,
      quantity: 20,
      expiryDate: '2024-08-20',
      status: 'normal',
      purchaseDate: '2024-05-20'
    },
    {
      id: 202,
      serviceName: '心理疏导',
      serviceType: '心理护理',
      unitPrice: 100,
      quantity: 8,
      expiryDate: '2024-07-05',
      status: 'normal',
      purchaseDate: '2024-05-25'
    }
  ],
  3: [
    {
      id: 301,
      serviceName: '基础护理',
      serviceType: '日常护理',
      unitPrice: 50,
      quantity: 25,
      expiryDate: '2024-09-01',
      status: 'normal',
      purchaseDate: '2024-06-01'
    },
    {
      id: 302,
      serviceName: '健康监测',
      serviceType: '医疗护理',
      unitPrice: 80,
      quantity: 12,
      expiryDate: '2024-08-15',
      status: 'normal',
      purchaseDate: '2024-06-01'
    },
    {
      id: 303,
      serviceName: '康复训练',
      serviceType: '康复护理',
      unitPrice: 120,
      quantity: 8,
      expiryDate: '2024-07-20',
      status: 'normal',
      purchaseDate: '2024-06-02'
    },
    {
      id: 304,
      serviceName: '营养配餐',
      serviceType: '生活护理',
      unitPrice: 60,
      quantity: 2,
      expiryDate: '2024-06-20',
      status: 'low_quantity',
      purchaseDate: '2024-06-03'
    }
  ]
})

// 计算属性
const filteredCustomers = computed(() => {
  if (!customerSearchKeyword.value) return customers.value
  return customers.value.filter(customer =>
    customer.name.includes(customerSearchKeyword.value)
  )
})

const filteredAvailableServices = computed(() => {
  let services = availableServices.value

  // 过滤掉已购买的服务
  if (selectedCustomer.value) {
    const purchasedServiceIds = customerServices.value.map(s => s.serviceName)
    services = services.filter(s => !purchasedServiceIds.includes(s.serviceName))
  }

  // 根据搜索关键词过滤
  if (serviceSearchKeyword.value) {
    services = services.filter(service =>
      service.serviceName.includes(serviceSearchKeyword.value)
    )
  }

  return services
})

const totalAmount = computed(() => {
  return selectedServices.value.reduce((total, service) => {
    return total + (service.unitPrice * service.quantity)
  }, 0)
})

// 方法
const handleCustomerSearch = () => {
  // 搜索客户的逻辑
}

const handleSelectCustomer = (customer: Customer) => {
  selectedCustomer.value = customer
  loadCustomerServices(customer.id)
}

const loadCustomerServices = (customerId: number) => {
  servicesLoading.value = true
  setTimeout(() => {
    customerServices.value = customerServiceData[customerId] || []
    servicesLoading.value = false
  }, 500)
}

const handleAddService = (customer: Customer) => {
  selectedCustomer.value = customer
  selectedServices.value = []
  serviceSearchKeyword.value = ''
  purchaseDialogVisible.value = true
}

const handleServiceSelection = (services: AvailableService[]) => {
  // 添加新选择的服务
  services.forEach(service => {
    const exists = selectedServices.value.find(s => s.id === service.id)
    if (!exists) {
      selectedServices.value.push({
        ...service,
        quantity: 1,
        expiryDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0] // 默认30天后过期
      })
    }
  })

  // 移除未选择的服务
  selectedServices.value = selectedServices.value.filter(selectedService =>
    services.find(s => s.id === selectedService.id)
  )
}

const removeSelectedService = (index: number) => {
  selectedServices.value.splice(index, 1)
}

const handleConfirmPurchase = async () => {
  if (!selectedCustomer.value || selectedServices.value.length === 0) return

  try {
    await ElMessageBox.confirm(
      `确定要为客户 ${selectedCustomer.value.name} 购买 ${selectedServices.value.length} 项服务吗？总金额: ¥${totalAmount.value.toLocaleString()}`,
      '确认购买',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )

    purchaseSubmitting.value = true

    // 模拟购买操作
    setTimeout(() => {
      const currentDate = new Date().toISOString().split('T')[0]
      const newServices = selectedServices.value.map((service, index) => ({
        id: Date.now() + index,
        serviceName: service.serviceName,
        serviceType: service.serviceType,
        unitPrice: service.unitPrice,
        quantity: service.quantity,
        expiryDate: service.expiryDate,
        status: 'normal' as const,
        purchaseDate: currentDate
      }))

      // 添加到客户服务列表
      if (!customerServiceData[selectedCustomer.value!.id]) {
        customerServiceData[selectedCustomer.value!.id] = []
      }
      customerServiceData[selectedCustomer.value!.id].push(...newServices)
      customerServices.value.push(...newServices)

      // 更新客户服务数量
      selectedCustomer.value!.serviceCount += selectedServices.value.length

      purchaseSubmitting.value = false
      purchaseDialogVisible.value = false
      selectedServices.value = []

      ElMessage.success('购买成功')
    }, 1000)
  } catch (error) {
    purchaseSubmitting.value = false
  }
}

const handleRenewService = (service: ServiceItem) => {
  currentService.value = service
  renewForm.addQuantity = 1
  renewForm.newExpiryDate = ''
  renewDialogVisible.value = true
}

const handleConfirmRenew = async () => {
  if (!currentService.value || !renewForm.newExpiryDate) {
    ElMessage.warning('请填写完整的续费信息')
    return
  }

  try {
    await ElMessageBox.confirm(
      `确定要为服务项目 ${currentService.value.serviceName} 续费吗？新增数量: ${renewForm.addQuantity}，续费金额: ¥${(renewForm.addQuantity * currentService.value.unitPrice).toLocaleString()}`,
      '确认续费',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )

    renewSubmitting.value = true

    // 模拟续费操作
    setTimeout(() => {
      currentService.value!.quantity += renewForm.addQuantity
      currentService.value!.expiryDate = renewForm.newExpiryDate
      currentService.value!.status = 'normal'

      renewSubmitting.value = false
      renewDialogVisible.value = false

      ElMessage.success('续费成功')
    }, 1000)
  } catch (error) {
    renewSubmitting.value = false
  }
}

const handleRemoveService = async (service: ServiceItem) => {
  try {
    await ElMessageBox.confirm(
      `确定要移除服务项目 ${service.serviceName} 吗？移除后客户将不再享有该服务，请谨慎操作！`,
      '确认移除',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'error'
      }
    )

    // 从客户服务列表中移除
    const index = customerServices.value.findIndex(s => s.id === service.id)
    if (index > -1) {
      customerServices.value.splice(index, 1)
    }

    // 从数据中移除
    if (selectedCustomer.value && customerServiceData[selectedCustomer.value.id]) {
      const dataIndex = customerServiceData[selectedCustomer.value.id].findIndex(s => s.id === service.id)
      if (dataIndex > -1) {
        customerServiceData[selectedCustomer.value.id].splice(dataIndex, 1)
      }
    }

    // 更新客户服务数量
    if (selectedCustomer.value) {
      selectedCustomer.value.serviceCount -= 1
    }

    ElMessage.success('服务移除成功')
  } catch (error) {
    // 用户取消操作
  }
}

// 工具方法
const getQuantityType = (quantity: number) => {
  if (quantity === 0) return 'danger'
  if (quantity <= 5) return 'warning'
  return 'success'
}

const getExpiryClass = (expiryDate: string) => {
  const today = new Date()
  const expiry = new Date(expiryDate)
  const diffTime = expiry.getTime() - today.getTime()
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))

  if (diffDays < 0) return 'expired-text'
  if (diffDays <= 7) return 'warning-text'
  return ''
}

const getStatusType = (status: string) => {
  switch (status) {
    case 'normal': return 'success'
    case 'low_quantity': return 'warning'
    case 'expired': return 'danger'
    case 'overdue': return 'danger'
    default: return 'info'
  }
}

const getStatusText = (status: string) => {
  switch (status) {
    case 'normal': return '正常'
    case 'low_quantity': return '数量不足'
    case 'expired': return '已过期'
    case 'overdue': return '已欠费'
    default: return '未知'
  }
}

const disabledDate = (time: Date) => {
  return time.getTime() < Date.now() - 8.64e7 // 不能选择今天之前的日期
}

// 生命周期
onMounted(() => {
  // 初始化数据
})
</script>

<style scoped>
.service-monitor {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
  padding: 20px;
}

.page-header-card {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  margin-bottom: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-header h2 {
  margin: 0;
  color: #333;
  font-weight: 600;
}

.customer-list-card,
.service-list-card {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-area,
.header-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.service-details {
  margin-top: 20px;
}

.purchase-content h3 {
  margin: 20px 0 10px 0;
  color: #333;
  font-size: 16px;
  font-weight: 600;
}

.service-search {
  margin-bottom: 15px;
}

.available-services,
.selected-services {
  margin-bottom: 20px;
}

.available-services {
  background: #f8f9fa;
  padding: 15px;
  border-radius: 8px;
  border: 1px solid #e9ecef;
}

.selected-services {
  background: #fff3cd;
  padding: 15px;
  border-radius: 8px;
  border: 1px solid #ffeaa7;
}

/* 对话框内表格样式优化 */
.purchase-content :deep(.el-table) {
  font-size: 13px;
}

.purchase-content :deep(.el-table th) {
  padding: 8px 0;
  font-size: 13px;
}

.purchase-content :deep(.el-table td) {
  padding: 8px 0;
}

.purchase-content :deep(.el-input-number) {
  width: 100px !important;
}

.purchase-content :deep(.el-date-editor) {
  width: 160px !important;
}

.total-amount {
  text-align: right;
  margin-top: 15px;
  padding: 15px;
  background: rgba(255, 193, 7, 0.1);
  border-radius: 8px;
}

.expired-text {
  color: #f56c6c;
  font-weight: bold;
}

.warning-text {
  color: #e6a23c;
  font-weight: bold;
}

:deep(.el-table) {
  background: transparent;
}

:deep(.el-table th.el-table__cell) {
  background: rgba(64, 158, 255, 0.1);
  color: #333;
}

:deep(.el-table .el-table__row) {
  background: rgba(255, 255, 255, 0.8);
}

:deep(.el-table .el-table__row:hover) {
  background: rgba(64, 158, 255, 0.1);
}

:deep(.el-table .current-row) {
  background: rgba(64, 158, 255, 0.2) !important;
}

.el-empty {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 8px;
  padding: 40px;
  text-align: center;
}
</style>
