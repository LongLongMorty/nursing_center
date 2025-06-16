import request from '@/utils/request'
import type { PageResponse } from './types'

// 系统管理相关API接口

// 用户信息接口
export interface User {
  id: number
  username: string
  realName: string
  role: string
  phone?: string
  status: number // 0-禁用 1-启用
  createTime: string
  updateTime?: string
}

// 系统用户接口（别名）
export interface SysUser extends User {}

// 用户创建/更新DTO
export interface UserDTO {
  id?: number
  username: string
  realName: string
  role: string
  phone?: string
  password?: string
  status?: number
}

// 系统用户DTO（别名）
export interface SysUserDTO extends UserDTO {}

// 用户查询DTO
export interface UserQueryDTO {
  pageNum: number
  pageSize: number
  username?: string
  name?: string
  phone?: string
  role?: string
  status?: number
  createTimeStart?: string
  createTimeEnd?: string
}

// 密码重置DTO
export interface PasswordResetDTO {
  newPassword: string
  confirmPassword: string
}

// 角色信息接口
export interface Role {
  id: number
  name: string
  description?: string
  permissions: string[]
  createdAt: string
  updatedAt?: string
}

// 角色创建/更新DTO
export interface RoleDTO {
  id?: number
  name: string
  description?: string
  permissions: string[]
}

// 护理级别接口
export interface CareLevel {
  id: number
  levelName: string
  description?: string
  price: number
  serviceItems: string[]
  createdAt: string
  updatedAt?: string
}

// 护理级别DTO
export interface CareLevelDTO {
  id?: number
  levelName: string
  description?: string
  price: number
  serviceItems: string[]
}

// 护理项目接口
export interface CareItem {
  id: number
  itemName: string
  description?: string
  category: string
  duration?: number
  price?: number
  isActive: boolean
  createdAt: string
  updatedAt?: string
}

// 护理项目DTO
export interface CareItemDTO {
  id?: number
  itemName: string
  description?: string
  category: string
  duration?: number
  price?: number
  isActive?: boolean
}

// 查询参数
export interface QueryParams {
  page?: number
  size?: number
  keyword?: string
  status?: string
  role?: string
  category?: string
}

// 系统管理API
export const systemApi = {
  // 用户管理
  user: {
    list: (params: UserQueryDTO): Promise<PageResponse<SysUser>> => {
      return request({
        url: '/api/admin/user/page',
        method: 'get',
        params
      })
    },

    getById: (id: number): Promise<SysUser> => {
      return request({
        url: `/api/admin/user/${id}`,
        method: 'get'
      })
    },

    create: (data: SysUserDTO): Promise<SysUser> => {
      return request({
        url: '/api/admin/user',
        method: 'post',
        data
      })
    },

    update: (data: SysUserDTO): Promise<SysUser> => {
      return request({
        url: '/api/admin/user',
        method: 'put',
        data
      })
    },

    delete: (id: number): Promise<void> => {
      return request({
        url: `/api/admin/user/${id}`,
        method: 'delete'
      })
    },

    updateStatus: (id: number, status: number): Promise<void> => {
      return request({
        url: `/api/admin/user/${id}/status`,
        method: 'put',
        data: { status }
      })
    },

    resetPassword: (id: number, newPassword: string): Promise<void> => {
      return request({
        url: `/api/admin/user/${id}/reset-password`,
        method: 'put',
        data: { newPassword }
      })
    },

    checkUsername: (username: string, excludeId?: number): Promise<boolean> => {
      return request({
        url: '/api/admin/user/check-username',
        method: 'get',
        params: { username, excludeId }
      })
    }
  },

  // 用户管理（旧API，保持向后兼容）
  getUsers: (params: UserQueryDTO): Promise<PageResponse<User>> => {
    return request({
      url: '/api/admin/user/page',
      method: 'get',
      params
    })
  },

  getUserById: (id: number): Promise<User> => {
    return request({
      url: `/api/admin/user/${id}`,
      method: 'get'
    })
  },

  createUser: (data: UserDTO): Promise<User> => {
    return request({
      url: '/api/admin/user',
      method: 'post',
      data
    })
  },

  updateUser: (data: UserDTO): Promise<User> => {
    return request({
      url: '/api/admin/user',
      method: 'put',
      data
    })
  },

  deleteUser: (id: number): Promise<void> => {
    return request({
      url: `/api/admin/user/${id}`,
      method: 'delete'
    })
  },

  batchDeleteUsers: (ids: number[]): Promise<void> => {
    return request({
      url: '/api/admin/user/batch',
      method: 'delete',
      data: ids
    })
  },

  resetPassword: (id: number, data: PasswordResetDTO): Promise<void> => {
    return request({
      url: `/api/admin/user/${id}/reset-password`,
      method: 'put',
      data
    })
  },

  resetUserPassword: (id: number, data: { password: string }): Promise<void> => {
    return request({
      url: `/api/admin/user/${id}/reset-password`,
      method: 'put',
      data
    })
  },

  toggleUserStatus: (id: number, status: number): Promise<void> => {
    return request({
      url: `/api/admin/user/${id}/status`,
      method: 'put',
      params: { status }
    })
  },

  checkUsername: (username: string, excludeId?: number): Promise<boolean> => {
    return request({
      url: '/api/admin/user/check-username',
      method: 'get',
      params: { username, excludeId }
    })
  },

  // 角色管理
  getRoles: (params: QueryParams): Promise<PageResponse<Role>> => {
    return request({
      url: '/api/admin/role/page',
      method: 'get',
      params
    })
  },

  getRoleById: (id: number): Promise<Role> => {
    return request({
      url: `/api/admin/role/${id}`,
      method: 'get'
    })
  },

  createRole: (data: RoleDTO): Promise<Role> => {
    return request({
      url: '/api/admin/role',
      method: 'post',
      data
    })
  },

  updateRole: (data: RoleDTO): Promise<Role> => {
    return request({
      url: '/api/admin/role',
      method: 'put',
      data
    })
  },

  deleteRole: (id: number): Promise<void> => {
    return request({
      url: `/api/admin/role/${id}`,
      method: 'delete'
    })
  },

  // 护理级别管理
  getCareLevels: (params: QueryParams): Promise<PageResponse<CareLevel>> => {
    return request({
      url: '/api/admin/care-level/page',
      method: 'get',
      params
    })
  },

  getCareLevelById: (id: number): Promise<CareLevel> => {
    return request({
      url: `/api/admin/care-level/${id}`,
      method: 'get'
    })
  },

  createCareLevel: (data: CareLevelDTO): Promise<CareLevel> => {
    return request({
      url: '/api/admin/care-level',
      method: 'post',
      data
    })
  },

  updateCareLevel: (data: CareLevelDTO): Promise<CareLevel> => {
    return request({
      url: '/api/admin/care-level',
      method: 'put',
      data
    })
  },

  deleteCareLevel: (id: number): Promise<void> => {
    return request({
      url: `/api/admin/care-level/${id}`,
      method: 'delete'
    })
  },

  // 护理项目管理
  getCareItems: (params: QueryParams): Promise<PageResponse<CareItem>> => {
    return request({
      url: '/api/admin/care-item/page',
      method: 'get',
      params
    })
  },

  getCareItemById: (id: number): Promise<CareItem> => {
    return request({
      url: `/api/admin/care-item/${id}`,
      method: 'get'
    })
  },

  createCareItem: (data: CareItemDTO): Promise<CareItem> => {
    return request({
      url: '/api/admin/care-item',
      method: 'post',
      data
    })
  },

  updateCareItem: (data: CareItemDTO): Promise<CareItem> => {
    return request({
      url: '/api/admin/care-item',
      method: 'put',
      data
    })
  },

  deleteCareItem: (id: number): Promise<void> => {
    return request({
      url: `/api/admin/care-item/${id}`,
      method: 'delete'
    })
  }
}
