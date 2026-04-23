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

        // クリックされたボタンがすでにactiveかチェック
        const isActive = button.classList.contains('active');

        if (isActive) {
          // すでにactiveなら解除
          button.classList.remove('active');
          
          // hidden_fieldの値をクリア
          if (hiddenField) {
            hiddenField.value = '';
          }
        } else {
          // activeでない場合は通常の選択処理
          // 同じグループ内の他のボタンのactiveを解除
          buttons.forEach(btn => btn.classList.remove('active'));

          // クリックされたボタンをactiveに
          button.classList.add('active');

          // hidden_fieldに値を設定
          if (hiddenField) {
            hiddenField.value = button.dataset.value;
          }
        }
      });
    });
  });

  // フォーム送信時の処理
  const form = document.querySelector('.main-form');
  if (!form) return;

  form.addEventListener('submit', (e) => {
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