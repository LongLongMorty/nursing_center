<template>
  <el-dialog
    :model-value="visible"
    :title="isEdit ? '编辑用户' : '新增用户'"
    width="600px"
    @update:model-value="$emit('update:visible', $event)"
    @close="handleClose"
  >
    <el-form
      ref="formRef"
      :model="formData"
      :rules="rules"
      label-width="100px"
    >
      <el-form-item label="用户名" prop="username">
        <el-input
          v-model="formData.username"
          placeholder="请输入用户名"
          :disabled="isEdit"
        />
      </el-form-item>
      
      <el-form-item label="真实姓名" prop="realName">
        <el-input
          v-model="formData.realName"
          placeholder="请输入真实姓名"
        />
      </el-form-item>
      
      <el-form-item label="手机号" prop="phone">
        <el-input
          v-model="formData.phone"
          placeholder="请输入手机号"
        />
      </el-form-item>
      
      <el-form-item label="用户角色" prop="role">
        <el-select v-model="formData.role" placeholder="请选择用户角色">
          <el-option label="管理员" value="ADMIN" />
          <el-option label="健康管家" value="HEALTH_MANAGER" />
        </el-select>
      </el-form-item>
      
      <el-form-item label="状态" prop="status">
        <el-select v-model="formData.status" placeholder="请选择状态">
          <el-option label="启用" :value="1" />
          <el-option label="禁用" :value="0" />
        </el-select>
      </el-form-item>
      
      <el-form-item v-if="!isEdit" label="密码" prop="password">
        <el-input
          v-model="formData.password"
          type="password"
          placeholder="请输入密码"
          show-password
        />
      </el-form-item>
    </el-form>
    
    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="loading">
          确定
        </el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, reactive, watch, nextTick } from 'vue'
import { ElMessage, type FormInstance, type FormRules } from 'element-plus'
import { systemApi } from '@/api'
import type { SysUser, SysUserDTO } from '@/api/system'

interface Props {
  visible: boolean
  userData?: SysUser
}

interface Emits {
  (e: 'update:visible', visible: boolean): void
  (e: 'success'): void
}

const props = withDefaults(defineProps<Props>(), {
  userData: undefined
})

const emit = defineEmits<Emits>()

const formRef = ref<FormInstance>()
const loading = ref(false)
const isEdit = ref(false)

const formData = reactive<SysUserDTO>({
  username: '',
  realName: '',
  phone: '',
  role: 'HEALTH_MANAGER',
  status: 1,
  password: ''
})

const rules: FormRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度必须在3-20位之间', trigger: 'blur' },
    { pattern: /^[a-zA-Z0-9_]+$/, message: '用户名只能包含字母、数字和下划线', trigger: 'blur' }
  ],
  realName: [
    { required: true, message: '请输入真实姓名', trigger: 'blur' },
    { max: 50, message: '真实姓名长度不能超过50位', trigger: 'blur' }
  ],
  phone: [
    { pattern: /^1[3-9]\d{9}$/, message: '手机号格式不正确', trigger: 'blur' }
  ],
  role: [
    { required: true, message: '请选择用户角色', trigger: 'change' }
  ],
  status: [
    { required: true, message: '请选择状态', trigger: 'change' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度必须在6-20位之间', trigger: 'blur' }
  ]
}

watch(() => props.visible, (newVal) => {
  if (newVal) {
    resetForm()
    if (props.userData) {
      isEdit.value = true
      Object.assign(formData, {
        id: props.userData.id,
        username: props.userData.username,
        realName: props.userData.realName,
        phone: props.userData.phone,
        role: props.userData.role,
        status: props.userData.status
      })
    } else {
      isEdit.value = false
    }
  }
})

const resetForm = () => {
  Object.assign(formData, {
    username: '',
    realName: '',
    phone: '',
    role: 'HEALTH_MANAGER',
    status: 1,
    password: ''
  })
  nextTick(() => {
    formRef.value?.clearValidate()
  })
}

const handleClose = () => {
  emit('update:visible', false)
  resetForm()
}

const handleSubmit = async () => {
  if (!formRef.value) return
  
  try {
    await formRef.value.validate()
    loading.value = true
    
    if (isEdit.value) {
      await systemApi.updateUser(formData)
      ElMessage.success('用户更新成功')
    } else {
      await systemApi.createUser(formData)
      ElMessage.success('用户创建成功')
    }
    
    emit('success')
    handleClose()
  } catch (error) {
    console.error('操作失败:', error)
    ElMessage.error(isEdit.value ? '用户更新失败' : '用户创建失败')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.dialog-footer {
  text-align: right;
}
</style>
