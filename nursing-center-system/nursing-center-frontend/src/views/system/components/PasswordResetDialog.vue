<template>
  <el-dialog
    :model-value="visible"
    title="重置用户密码"
    width="500px"
    @update:model-value="$emit('update:visible', $event)"
    @close="handleClose"
  >
    <el-form
      ref="formRef"
      :model="formData"
      :rules="rules"
      label-width="100px"
    >
      <el-form-item label="新密码" prop="password">
        <el-input
          v-model="formData.password"
          type="password"
          placeholder="请输入新密码"
          show-password
          clearable
        />
        <div class="password-tips">
          <small class="tip-text">密码长度6-20位，建议包含字母、数字和特殊字符</small>
        </div>
      </el-form-item>
      
      <el-form-item label="确认密码" prop="confirmPassword">
        <el-input
          v-model="formData.confirmPassword"
          type="password"
          placeholder="请再次输入新密码"
          show-password
          clearable
        />
      </el-form-item>
      
      <el-form-item>
        <el-checkbox v-model="generateRandom">
          生成随机密码
        </el-checkbox>
        <el-button 
          v-if="generateRandom" 
          type="text" 
          @click="handleGeneratePassword"
          style="margin-left: 10px;"
        >
          生成密码
        </el-button>
      </el-form-item>
    </el-form>
    
    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="loading">
          确定重置
        </el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, reactive, watch, nextTick } from 'vue'
import { ElMessage, type FormInstance, type FormRules } from 'element-plus'
import { systemApi } from '@/api'

interface Props {
  visible: boolean
  userId: number
}

interface Emits {
  (e: 'update:visible', visible: boolean): void
  (e: 'success'): void
}

const props = defineProps<Props>()
const emit = defineEmits<Emits>()

const formRef = ref<FormInstance>()
const loading = ref(false)
const generateRandom = ref(false)

const formData = reactive({
  password: '',
  confirmPassword: ''
})

// 验证确认密码
const validateConfirmPassword = (rule: any, value: string, callback: any) => {
  if (value !== formData.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const rules: FormRules = {
  password: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度必须在6-20位之间', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ]
}

// 生成随机密码
const handleGeneratePassword = () => {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*'
  let password = ''
  
  // 确保包含大写字母、小写字母、数字和特殊字符各一个
  password += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'[Math.floor(Math.random() * 26)]
  password += 'abcdefghijklmnopqrstuvwxyz'[Math.floor(Math.random() * 26)]
  password += '0123456789'[Math.floor(Math.random() * 10)]
  password += '!@#$%^&*'[Math.floor(Math.random() * 8)]
  
  // 剩余4位随机字符
  for (let i = 0; i < 4; i++) {
    password += chars[Math.floor(Math.random() * chars.length)]
  }
  
  // 打乱字符顺序
  const shuffled = password.split('').sort(() => Math.random() - 0.5).join('')
  
  formData.password = shuffled
  formData.confirmPassword = shuffled
  
  ElMessage.success('已生成随机密码')
}

const resetForm = () => {
  formData.password = ''
  formData.confirmPassword = ''
  generateRandom.value = false
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
    
    await systemApi.resetUserPassword(props.userId, {
      password: formData.password
    })
    
    ElMessage.success('密码重置成功')
    emit('success')
    handleClose()
  } catch (error) {
    console.error('密码重置失败:', error)
    ElMessage.error('密码重置失败，请重试')
  } finally {
    loading.value = false
  }
}

// 监听生成随机密码开关
watch(generateRandom, (newVal) => {
  if (newVal) {
    handleGeneratePassword()
  } else {
    formData.password = ''
    formData.confirmPassword = ''
  }
})

watch(() => props.visible, (newVal) => {
  if (newVal) {
    resetForm()
  }
})
</script>

<style scoped>
.dialog-footer {
  text-align: right;
}

.password-tips {
  margin-top: 5px;
}

.tip-text {
  color: #909399;
  font-size: 12px;
}
</style>
