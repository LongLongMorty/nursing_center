import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/stores/user'
import Layout from '@/components/Layout.vue'
import HomeView from '@/views/HomeView.vue'
import LoginView from '@/views/LoginView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/login',
      name: 'login',
      component: LoginView,
      meta: { requiresAuth: false }
    },
    {
      path: '/',
      component: Layout,
      meta: { requiresAuth: true },
      children: [
        {
          path: '',
          name: 'home',
          component: HomeView
        },
        {
          path: '/customer',
          name: 'customer',
          children: [
            {
              path: 'list',
              name: 'customer-list',
              component: () => import('@/views/customer/CustomerList.vue')
            },
            {
              path: 'checkin',
              name: 'customer-checkin',
              component: () => import('@/views/customer/CheckInRegistration.vue')
            },
            {
              path: 'checkout',
              name: 'customer-checkout',
              component: () => import('@/views/apply/ApplyManagement.vue')
            },
            {
              path: 'outing',
              name: 'customer-outing',
              component: () => import('@/views/apply/ApplyManagement.vue')
            },
            {
              path: 'return',
              name: 'customer-return',
              component: () => import('@/views/apply/ReturnApplyManagement.vue')
            },
            {
              path: 'add',
              name: 'customer-add',
              component: () => import('@/views/customer/CustomerAdd.vue')
            },
            {
              path: 'detail/:id',
              name: 'customer-detail',
              component: () => import('@/views/customer/CustomerDetail.vue')
            },
            {
              path: 'edit/:id',
              name: 'customer-edit',
              component: () => import('@/views/customer/CustomerEdit.vue')
            },
            {
              path: 'care',
              name: 'customer-care',
              component: () => import('@/views/care/CareManagement.vue')
            }
          ]
        },
        {
          path: '/bed',
          name: 'bed',
          children: [
            {
              path: 'diagram',
              name: 'bed-diagram',
              component: () => import('@/views/bed/BedDiagram.vue')
            },
            {
              path: 'usage',
              name: 'bed-usage',
              component: () => import('@/views/bed/BedUsageManagement.vue')
            }
          ]
        },
        {
          path: '/nursing',
          name: 'nursing',
          children: [
            {
              path: 'level',
              name: 'nursing-level',
              component: () => import('@/views/nursing/CareLevel.vue')
            },
            {
              path: 'item',
              name: 'nursing-item',
              component: () => import('@/views/nursing/CareItem.vue')
            },
            {
              path: 'customer-care',
              name: 'nursing-customer-care',
              component: () => import('@/views/nursing/CustomerCare.vue')
            },
            {
              path: 'record',
              name: 'nursing-record',
              component: () => import('@/views/nursing/CareRecord.vue')
            }
          ]
        },
        {
          path: '/health-manager',
          name: 'health-manager',
          children: [
            {
              path: '',
              redirect: '/health-manager/assign'
            },
            {
              path: 'assign',
              name: 'health-manager-assign',
              component: () => import('@/views/healthManager/ServiceAssignment.vue')
            },
            {
              path: 'monitor',
              name: 'health-manager-monitor',
              component: () => import('@/views/healthManager/ServiceMonitor.vue')
            }
          ]
        },
        {
          path: '/meal',
          name: 'meal',
          children: [
            {
              path: 'plan',
              name: 'meal-plan',
              component: () => import('@/views/meal/MealPlan.vue')
            },
            {
              path: 'nutrition',
              name: 'meal-nutrition',
              component: () => import('@/views/meal/Nutrition.vue')
            },
            {
              path: 'config',
              name: 'meal-config',
              component: () => import('@/views/meal/MealPlan.vue') // 暂时使用同一个组件
            }
          ]
        },
        {
          path: '/system',
          name: 'system',
          children: [
            {
              path: 'user',
              name: 'system-user',
              component: () => import('@/views/system/UserManagement.vue')
            },
            {
              path: 'role',
              name: 'system-role',
              component: () => import('@/views/system/RoleManagement.vue')
            },
            {
              path: 'logs',
              name: 'system-logs',
              component: () => import('@/views/system/UserManagement.vue') // 暂时使用用户管理组件
            }
          ]
        }
      ]
    }
  ]
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const userStore = useUserStore()

  // 如果store中没有用户信息但localStorage中有token，先恢复用户状态
  if (!userStore.userInfo && localStorage.getItem('token')) {
    userStore.initUserInfo()
  }

  if (to.meta.requiresAuth === false) {
    // 不需要认证的页面
    if (to.path === '/login' && userStore.isLoggedIn) {
      // 已登录用户访问登录页，重定向到首页
      next('/')
    } else {
      next()
    }
  } else {
    // 需要认证的页面
    if (!userStore.isLoggedIn) {
      next('/login')
    } else {
      next()
    }
  }
})

export default router
