import "@hotwired/turbo-rails"
import "./lp_demo"

// ① ボタン（UI）
document.addEventListener('click', (e) => {
  const button = e.target.closest('.status-btn');
  if (!button) return;

  const group = button.closest('.status-buttons');
  if (!group) return;

  const targetId = group.dataset.target;
  const hiddenField = targetId ? document.getElementById(targetId) : null;
  const buttons = group.querySelectorAll('.status-btn');
  
  const isActive = button.classList.contains('active');
  // 全解除
  buttons.forEach(btn => btn.classList.remove('active'));

  if (isActive) {
    if (hiddenField) hiddenField.value = '';
  } else {
    button.classList.add('active');
    if (hiddenField) hiddenField.value = button.dataset.value;
  }
});


// ② フォーム送信
const initStepForm = () => {
  const form = document.querySelector('.main-form');
  if (!form) return;

  form.addEventListener('submit', (e) => {
    const feelingField = document.getElementById('feeling-field');

    if (!feelingField?.value) {
      e.preventDefault();
      alert('今の気持ちを選択してください');
      return;
    }

    const submitBtn = form.querySelector('[type="submit"]');
    if (submitBtn) {
      submitBtn.disabled = true;
      submitBtn.textContent = '送信中...';
    }

    const loadingIndicator = document.getElementById('loading-indicator');
    if (loadingIndicator) {
      loadingIndicator.classList.remove('hidden');
    }
  });
};


// ③ 初期化
document.addEventListener("DOMContentLoaded", initStepForm);
document.addEventListener("turbo:load", initStepForm);
