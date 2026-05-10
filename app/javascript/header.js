// ハンバーガーメニューの初期化処理
const initHamburgerMenu = () => {
  const hamburgerBtn = document.getElementById('hamburger-btn');
  const hamburgerMenu = document.getElementById('hamburger-menu');

  if (hamburgerBtn && hamburgerMenu) {
    hamburgerBtn.addEventListener('click', () => {
      hamburgerBtn.classList.toggle('active');
      hamburgerMenu.classList.toggle('active');
    });

    // メニュー外をクリックしたら閉じる
    document.addEventListener('click', (event) => {
      if (!hamburgerBtn.contains(event.target) && !hamburgerMenu.contains(event.target)) {
        hamburgerBtn.classList.remove('active');
        hamburgerMenu.classList.remove('active');
      }
    });

    // メニュー内のリンクをクリックしたら閉じる
    const menuLinks = hamburgerMenu.querySelectorAll('.hamburger-link');
    menuLinks.forEach(link => {
      link.addEventListener('click', () => {
        hamburgerBtn.classList.remove('active');
        hamburgerMenu.classList.remove('active');
      });
    });
  }
};

// DOMContentLoaded と turbo:load の両方でイベントをリスニング
document.addEventListener('DOMContentLoaded', initHamburgerMenu);
document.addEventListener('turbo:load', initHamburgerMenu);