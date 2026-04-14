const initStepForm = () => {
  // ボタン選択の処理
  const buttonGroups = document.querySelectorAll('.status-buttons');

  buttonGroups.forEach(group => {
    const buttons = group.querySelectorAll('.status-btn');
    // data属性でhidden fieldと紐付け
    const targetId = group.dataset.target;
    const hiddenField = targetId ? document.getElementById(targetId) : null;

    buttons.forEach(button => {
      button.addEventListener('click', (e) => {
        e.preventDefault();

        // 同じグループ内の他のボタンのactiveを解除
        buttons.forEach(btn => btn.classList.remove('active'));

        // クリックされたボタンをactiveに
        button.classList.add('active');

        // hidden_fieldに値を設定
        if (hiddenField) {
          hiddenField.value = button.dataset.value;
        }
      });
    });
  });

  // フォーム送信時の処理
  const form = document.querySelector('form');
  if (!form) return;

  // エラー表示用の関数
  const showError = (message) => {
    let errorEl = document.getElementById('form-error');
    if (!errorEl) {
      errorEl = document.createElement('p');
      errorEl.id = 'form-error';
      errorEl.style.cssText = 'color:#e76f51; font-size:14px; margin-bottom:12px; text-align:center;';
      form.prepend(errorEl);
    }
    errorEl.textContent = message;
    errorEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
  };

  // エラーをクリアする関数
  const clearError = () => {
    const errorEl = document.getElementById('form-error');
    if (errorEl) errorEl.textContent = '';
  };

  form.addEventListener('submit', (e) => {
    clearError();

    const goal = document.querySelector('textarea[name="step[goal]"]');
    const feeling = document.getElementById('feeling-field');
    const timeAvailable = document.getElementById('time-available-field');

    if (!goal || !goal.value.trim()) {
      e.preventDefault();
      showError('「気になっていること」を入力してください');
      return;
    }

    if (!feeling?.value || !timeAvailable?.value) {
      e.preventDefault();
      showError('「今の気持ち」と「今から使える時間」を選択してください');
      return;
    }

    // バリデーション通過後：二重送信対策
    const submitBtn = form.querySelector('[type="submit"]');
    if (submitBtn) {
      submitBtn.disabled = true;
      submitBtn.textContent = '送信中...';
    }
  });
};

// Turbo対応 + フォールバック
document.addEventListener('turbo:load', initStepForm);
document.addEventListener('DOMContentLoaded', initStepForm);