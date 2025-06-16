import request from '@/utils/request'
import type { PageResponse, BaseQueryParams } from './types'

// 健康管家接口
export interface HealthManager {
  id: number
  username: string
  realName: string
  phone: string
  role: string
  status: number // 0-禁用 1-启用
  totalCustomers?: number // 服务客户总数
  activeCustomers?: number // 在住客户数
  // 向后兼容字段
  userId?: number
  userName?: string
  name?: string // 别名，为了向后兼容
  employeeId?: string // 工号
  email?: string
  specialties?: string[] // 专业领域
  workExperience?: number // 工作经验（年）
  certifications?: string[] // 资格证书
  maxCustomers?: number // 最大服务客户数
  currentCustomers?: number // 当前服务客户数
  assignedCount?: number // 已分配客户数（别名）
  maxCapacity?: number // 最大容量（别名）
  department?: string // 部门
  qualification?: string // 资质
  createTime?: string
  updateTime?: string
}

// 健康管家DTO
export interface HealthManagerDTO {
  id?: number
  userId?: number
  realName: string
  name?: string // 别名，为了向后兼容
  employeeId?: string // 工号
  phone: string
  email?: string
  specialties: string[]
  workExperience: number
  experience?: number // 别名，为了向后兼容
  certifications: string[]
  maxCustomers: number
  qualification?: string // 专业资质
  department?: string // 部门
  description?: string // 描述
  status?: string
}

// 服务分配接口
export interface ServiceAssignment {
  id: number
  healthManagerId: number
  healthManagerName: string
  customerId: number
  customerName: string
  assignDate: string
  status: string // ACTIVE, COMPLETED, CANCELLED
  notes?: string
  createTime: string
  updateTime?: string
}

// 服务分配DTO
export interface ServiceAssignmentDTO {
  id?: number
  healthManagerId: string
  customerId: string
  serviceType: string
  startTime: string
  endTime: string
  serviceContent: string
  specialRequirements: string
  assignDate?: string
  notes?: string
  status?: string
}

// 服务监控数据接口
export interface ServiceMonitor {
  id: number
  customerId: number
  customerName: string
  healthManagerId: number
  healthManagerName: string
  serviceType: string // CARE, MEAL, HEALTH
  status: string // NORMAL, EXPIRED, ARREARS, USED_UP
  lastServiceDate?: string
  nextServiceDate?: string
  alertLevel: string // LOW, MEDIUM, HIGH
  alertMessage?: string
  createTime: string
  updateTime?: string
  // ServiceAlert 兼容属性
  roomNumber?: string
  alertTime?: string
  alertType?: string
  level?: string // 别名 for alertLevel
  message?: string // 别名 for alertMessage
  metrics?: Record<string, any>
  processHistory?: {
    id: string
    handlerName: string
    status: string
    notes: string
    processTime: string
    actions?: string[]
  }[]
}

// 健康管家查询参数
export interface HealthManagerQueryParams extends BaseQueryParams {
  page?: number
  size?: number
  userName?: string
  realName?: string
  status?: string
  specialty?: string
}

// 服务分配查询参数
export interface ServiceAssignmentQueryParams extends BaseQueryParams {
  page?: number
  size?: number
  healthManagerId?: number
  customerId?: number
  customerName?: string
  healthManagerName?: string
  status?: string
  startDate?: string
  endDate?: string
}

// 服务监控查询参数
export interface ServiceMonitorQueryParams extends BaseQueryParams {
  page?: number
  size?: number
  customerName?: string
  healthManagerName?: string
  serviceType?: string
  status?: string
  alertLevel?: string
}

// 健康管家统计数据
export interface HealthManagerStats {
  totalManagers: number
  activeManagers: number
  totalAssignments: number
  activeAssignments: number
  totalCustomers: number
  avgCustomersPerManager: number
  workloadDistribution: {
    managerId: number
    managerName: string
    customerCount: number
    maxCustomers: number
    utilizationRate: number
  }[]
  serviceAlerts: {
    expired: number
    arrears: number
    usedUp: number
    total: number
  }
}

// 健康管家管理API
export const healthManagerApi = {
  // 健康管家管理
  getHealthManager: {
    list: (params: HealthManagerQueryParams): Promise<PageResponse<HealthManager>> => {
      return request({
        url: '/api/admin/health-manager/page',
        method: 'get',
        params
      })
    },

    getById: (id: number): Promise<HealthManager> => {
      return request({
        url: `/api/admin/health-manager/${id}`,
        method: 'get'
      })
    },

    create: (data: HealthManagerDTO): Promise<HealthManager> => {
      return request({
        url: '/api/admin/health-manager',
        method: 'post',
        data
      })
    },

    update: (data: HealthManagerDTO): Promise<HealthManager> => {
      return request({
        url: '/api/admin/health-manager',
        method: 'put',
        data
      })
    },

    delete: (id: number): Promise<void> => {
      return request({
        url: `/api/admin/health-manager/${id}`,
        method: 'delete'
      })
    },    getAll: (): Promise<HealthManager[]> => {
      return request({
        url: '/api/admin/health-manager/page',
        method: 'get',
        params: { page: 1, size: 1000 } // 获取大量数据作为全部列表
      }).then((response: any) => response.records || response.data || [])
    },

    getAvailable: (): Promise<HealthManager[]> => {
      return request({
        url: '/api/admin/health-manager/available',
        method: 'get'
      })
    }
  },

  // 服务分配管理
  getServiceAssignment: {
    list: (params: ServiceAssignmentQueryParams): Promise<PageResponse<ServiceAssignment>> => {
      return request({
        url: '/api/admin/service-assignment/page',
        method: 'get',
        params
      })
    },

    getById: (id: number): Promise<ServiceAssignment> => {
      return request({
        url: `/api/admin/service-assignment/${id}`,
        method: 'get'
      })
    },

    create: (data: ServiceAssignmentDTO): Promise<ServiceAssignment> => {
      return request({
        url: '/api/admin/service-assignment',
        method: 'post',
        data
      })
    },

    update: (data: ServiceAssignmentDTO): Promise<ServiceAssignment> => {
      return request({
        url: '/api/admin/service-assignment',
        method: 'put',
        data
      })
    },

    delete: (id: number): Promise<void> => {
      return request({
        url: `/api/admin/service-assignment/${id}`,
        method: 'delete'
      })
    },

    getByCustomer: (customerId: number): Promise<ServiceAssignment[]> => {
      return request({
        url: `/api/admin/service-assignment/customer/${customerId}`,
        method: 'get'
      })
    },

    getByManager: (managerId: number): Promise<ServiceAssignment[]> => {
      return request({
        url: `/api/admin/service-assignment/manager/${managerId}`,
        method: 'get'
      })
    },

    batchAssign: (assignments: ServiceAssignmentDTO[]): Promise<ServiceAssignment[]> => {
      return request({
        url: '/api/admin/service-assignment/batch',
        method: 'post',
        data: assignments
      })
    }
  },

  // 服务监控管理
  getServiceMonitor: {
    list: (params: ServiceMonitorQueryParams): Promise<PageResponse<ServiceMonitor>> => {
      return request({
        url: '/api/admin/service-monitor/page',
        method: 'get',
        params
      })
    },

    getById: (id: number): Promise<ServiceMonitor> => {
      return request({
        url: `/api/admin/service-monitor/${id}`,
        method: 'get'
      })
    },

    getAlerts: (alertLevel?: string): Promise<ServiceMonitor[]> => {
      return request({
        url: '/api/admin/service-monitor/alerts',
        method: 'get',
        params: { alertLevel }
      })
    },

    handleAlert: (id: number, action: string, notes?: string): Promise<void> => {
      return request({
        url: `/api/admin/service-monitor/${id}/handle`,
        method: 'post',
        data: { action, notes }
      })
    },

    refreshStatus: (customerId?: number): Promise<void> => {
      return request({
        url: '/api/admin/service-monitor/refresh',
        method: 'post',
        data: { customerId }
      })
    }
  },
  // 客户分配相关API
  getUnassignedCustomers: (params: { customerName?: string }): Promise<any[]> => {
    return request({
      url: '/api/admin/health-manager/customers/without-manager',
      method: 'get',
      params
    })
  },

  getAssignedCustomers: (managerId: number): Promise<any[]> => {
    return request({
      url: `/api/admin/health-manager/${managerId}/customers`,
      method: 'get'
    })
  },
  batchAssignCustomers: (data: { healthManagerId: number; customerIds: number[] }): Promise<void> => {
    return request({
      url: '/api/admin/health-manager/set-customers',
      method: 'post',
      data: {
        healthManagerId: data.healthManagerId,
        customerIds: data.customerIds
      }
    })
  },

  removeCustomerAssignment: (data: { healthManagerId: number; customerId: number }): Promise<void> => {
    return request({
      url: '/api/admin/health-manager/remove-customers',
      method: 'post',
      data: {
        healthManagerId: data.healthManagerId,
        customerIds: [data.customerId]
      }
    })
  },

  // 获取健康管家统计
  getStats: (): Promise<HealthManagerStats> => {
    return request({
      url: '/api/admin/health-manager/stats',
      method: 'get'
    })
  },

  // 工作负载分析
  getWorkloadAnalysis: (managerId?: number): Promise<{
    managerId: number
    managerName: string
    customers: {
      id: number
      name: string
      assignDate: string
      careLevel: string
      status: string
    }[]
    workload: {
      totalCustomers: number
      maxCustomers: number
      utilizationRate: number
      avgCareLevel: string
    }
  }[]> => {
    return request({
      url: '/api/admin/health-manager/workload',
      method: 'get',
      params: { managerId }
    })
  }
}

// 独立的API函数供对话框组件使用
export const getHealthManagers = (params?: HealthManagerQueryParams): Promise<PageResponse<HealthManager>> => {
  return healthManagerApi.getHealthManager.list(params || {})
}

export const createHealthManager = (data: HealthManagerDTO): Promise<HealthManager> => {
  return healthManagerApi.getHealthManager.create(data)
}

export const updateHealthManager = (id: number, data: HealthManagerDTO): Promise<HealthManager> => {
  return healthManagerApi.getHealthManager.update({ ...data, id })
}

export const createServiceAssignment = (data: ServiceAssignmentDTO): Promise<ServiceAssignment> => {
  return healthManagerApi.getServiceAssignment.create(data)
}

export const batchCreateServiceAssignments = (data: BatchServiceAssignmentDTO): Promise<ServiceAssignment[]> => {
  // 将批量分配数据转换为单个分配数组
  const assignments: ServiceAssignmentDTO[] = data.customerIds.map(customerId => ({
    customerId,
    healthManagerId: data.manualAssignments?.[customerId] || '', 
    serviceType: data.serviceType,
    startTime: data.startTime,
    endTime: new Date(new Date(data.startTime).getTime() + data.duration * 24 * 60 * 60 * 1000).toISOString(),
    serviceContent: `批量分配的${data.serviceType}服务`,
    specialRequirements: ''
  }))
  
  return healthManagerApi.getServiceAssignment.batchAssign(assignments)
}

export const processServiceAlert = (data: AlertProcessDTO): Promise<void> => {
  return healthManagerApi.getServiceMonitor.handleAlert(
    parseInt(data.alertId), 
    data.status, 
    data.notes
  )
}

// 批量服务分配DTO
export interface BatchServiceAssignmentDTO {
  mode: string // AUTO, MANUAL, LOAD_BALANCE
  customerIds: string[]
  manualAssignments?: Record<string, string>
  serviceType: string
  startTime: string
  duration: number
}

// 预警处理DTO
export interface AlertProcessDTO {
  alertId: string
  status: string
  handlerId: string
  actions: string[]
  urgency: string
  notes: string
  expectedCompletionTime: string
  needFollowUp: boolean
  followUpTime?: string
}

// 服务预警接口
export interface ServiceAlert {
  id: string
  customerName: string
  roomNumber: string
  healthManagerName: string
  alertTime: string
  serviceType: string
  alertType: string
  level: string
  status: string
  message: string
  metrics?: Record<string, any>
  processHistory?: {
    id: string
    handlerName: string
    status: string
    notes: string
    processTime: string
    actions?: string[]
  }[]
}
