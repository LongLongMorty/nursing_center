import request from '@/utils/request'
import type { ApiResponse, PageResponse } from './types'

// 楼栋信息接口
export interface Building {
  id: number
  buildingName: string
  buildingNo: string
  floors: number
  description?: string
  status: number  // 0-禁用 1-启用
  totalRooms?: number
  totalBeds?: number
  occupiedBeds?: number
  createdAt?: string
  updatedAt?: string
}

// 楼栋创建/更新DTO
export interface BuildingDTO {
  id?: number
  buildingName: string
  buildingNo: string
  floors: number
  description?: string
  status?: number
}

// 楼栋查询DTO
export interface BuildingQueryDTO {
  pageNum: number
  pageSize: number
  buildingName?: string
  buildingNo?: string
  status?: number
}

// 楼栋API
export const buildingApi = {
  // 分页查询楼栋
  getBuildingPage: (query: BuildingQueryDTO): Promise<ApiResponse<PageResponse<Building>>> => {
    return request.get('/api/admin/building/page', { params: query })
  },

  // 根据ID查询楼栋详情
  getBuildingById: (id: number): Promise<ApiResponse<Building>> => {
    return request.get(`/api/admin/building/${id}`)
  },

  // 新增楼栋
  addBuilding: (building: BuildingDTO): Promise<ApiResponse<number>> => {
    return request.post('/api/admin/building', building)
  },

  // 更新楼栋
  updateBuilding: (building: BuildingDTO): Promise<ApiResponse<void>> => {
    return request.put('/api/admin/building', building)
  },

  // 删除楼栋
  deleteBuilding: (id: number): Promise<ApiResponse<void>> => {
    return request.delete(`/api/admin/building/${id}`)
  },

  // 获取所有启用的楼栋
  getEnabledBuildings: (): Promise<ApiResponse<Building[]>> => {
    return request.get('/api/admin/building/enabled')
  }
}

export default buildingApi
