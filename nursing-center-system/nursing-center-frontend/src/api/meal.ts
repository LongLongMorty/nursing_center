import request from '@/utils/request'
import type { PageResponse } from './types'

// 膳食管理相关API接口

// 膳食计划接口
export interface MealPlan {
  id: number
  customerId: number
  customerName: string
  planName: string
  mealType: string
  specialRequirements?: string
  allergies?: string
  startDate: string
  endDate: string
  status: string
  createdBy: string
  createdAt: string
  updatedAt?: string
}

// 膳食计划DTO
export interface MealPlanDTO {
  id?: number
  customerId: number
  planName: string
  mealType: string
  specialRequirements?: string
  allergies?: string
  startDate: string
  endDate: string
  status?: string
}

// 膳食日历接口
export interface MealCalendar {
  id: number
  mealDate: string
  mealType: string
  mealName: string
  mealDescription?: string
  nutritionInfo?: string
  enabled: boolean
  createdAt: string
  updatedAt?: string
}

// 膳食日历DTO
export interface MealCalendarDTO {
  id?: number
  mealDate: string
  mealType: string
  mealName: string
  mealDescription?: string
  nutritionInfo?: string
  enabled?: boolean
}

// 营养配置接口
export interface NutritionConfig {
  id: number
  configName: string
  description?: string
  caloriesMin: number
  caloriesMax: number
  proteinMin: number
  proteinMax: number
  fatMin: number
  fatMax: number
  carbohydrateMin: number
  carbohydrateMax: number
  enabled: boolean
  createdAt: string
  updatedAt?: string
}

// 营养评估接口
export interface NutritionAssessment {
  id: number
  customerId: number
  customerName: string
  assessmentDate: string
  height: number
  weight: number
  bmi: number
  nutritionStatus: string
  recommendations?: string
  assessorName: string
  createdAt: string
  updatedAt?: string
}

// 营养评估DTO
export interface NutritionAssessmentDTO {
  id?: number
  customerId: number
  assessmentDate: string
  height: number
  weight: number
  recommendations?: string
  assessorName?: string
}

// 查询参数
export interface MealQueryParams {
  page?: number
  size?: number
  customerName?: string
  mealType?: string
  planName?: string
  status?: string
  startDate?: string
  endDate?: string
}

// 膳食管理API
export const mealApi = {
  // 膳食计划相关
  getPlans: (params: MealQueryParams): Promise<PageResponse<MealPlan>> => {    return request({
      url: '/api/admin/meal-plan/page',
      method: 'get',
      params
    })
  },

  getPlanById: (id: number): Promise<MealPlan> => {
    return request({
      url: `/api/admin/meal-plan/${id}`,
      method: 'get'
    })
  },

  createPlan: (data: MealPlanDTO): Promise<MealPlan> => {
    return request({
      url: '/api/admin/meal-plan',
      method: 'post',
      data
    })
  },

  updatePlan: (data: MealPlanDTO): Promise<MealPlan> => {
    return request({
      url: '/api/admin/meal-plan',
      method: 'put',
      data
    })
  },

  deletePlan: (id: number): Promise<void> => {
    return request({
      url: `/api/admin/meal-plan/${id}`,
      method: 'delete'
    })
  },

  // 膳食日历相关
  getCalendar: (params: MealQueryParams): Promise<PageResponse<MealCalendar>> => {
    return request({
      url: '/api/admin/meal-calendar/page',
      method: 'get',
      params
    })
  },

  getCalendarById: (id: number): Promise<MealCalendar> => {
    return request({
      url: `/api/admin/meal-calendar/${id}`,
      method: 'get'
    })
  },

  createCalendar: (data: MealCalendarDTO): Promise<MealCalendar> => {
    return request({
      url: '/api/admin/meal-calendar',
      method: 'post',
      data
    })
  },

  updateCalendar: (data: MealCalendarDTO): Promise<MealCalendar> => {
    return request({
      url: '/api/admin/meal-calendar',
      method: 'put',
      data
    })
  },

  deleteCalendar: (id: number): Promise<void> => {
    return request({
      url: `/api/admin/meal-calendar/${id}`,
      method: 'delete'
    })
  },

  // 根据日期获取膳食安排
  getMealsByDate: (mealDate: string): Promise<MealCalendar[]> => {
    return request({
      url: `/api/admin/meal-calendar/date/${mealDate}`,
      method: 'get'
    })
  },

  // 根据日期范围获取膳食安排
  getMealsByDateRange: (startDate: string, endDate: string): Promise<MealCalendar[]> => {
    return request({
      url: '/api/admin/meal-calendar/date-range',
      method: 'get',
      params: { startDate, endDate }
    })
  },

  // 营养配置相关
  getNutritionConfigs: (): Promise<NutritionConfig[]> => {
    return request({
      url: '/api/admin/nutrition-config',
      method: 'get'
    })
  },
  // 获取膳食统计信息
  getStats: (): Promise<{
    totalPlans: number
    activePlans: number
    mealTypeStats: Array<{ mealType: string; count: number }>
  }> => {
    return request({
      url: '/api/admin/meal-plan/stats',
      method: 'get'
    })
  },

  // 营养评估相关
  getNutritionAssessments: (params: MealQueryParams): Promise<PageResponse<NutritionAssessment>> => {
    return request({
      url: '/api/admin/nutrition-assessment/page',
      method: 'get',
      params
    })
  },

  getNutritionAssessmentById: (id: number): Promise<NutritionAssessment> => {
    return request({
      url: `/api/admin/nutrition-assessment/${id}`,
      method: 'get'
    })
  },

  createNutritionAssessment: (data: NutritionAssessmentDTO): Promise<NutritionAssessment> => {
    return request({
      url: '/api/admin/nutrition-assessment',
      method: 'post',
      data
    })
  },

  updateNutritionAssessment: (data: NutritionAssessmentDTO): Promise<NutritionAssessment> => {
    return request({
      url: '/api/admin/nutrition-assessment',
      method: 'put',
      data
    })
  },

  deleteNutritionAssessment: (id: number): Promise<void> => {
    return request({
      url: `/api/admin/nutrition-assessment/${id}`,
      method: 'delete'
    })
  }
}
