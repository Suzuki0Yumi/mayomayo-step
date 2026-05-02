const initLpDemo = () => {
  // デモセクションがあるページでのみ実行
  const demoBox = document.querySelector('.lp-demo-box');
  if (!demoBox) return;

  // 要素の取得
  const topicInput = document.getElementById('lp-topic');
  const moodBtns = document.querySelectorAll('.lp-mood-btn');
  const runBtn = document.getElementById('lp-run-btn');
  const resultArea = document.getElementById('lp-result');
  const resultStep = document.getElementById('lp-result-step');
  const resultNote = document.getElementById('lp-result-note');
  const chips = document.querySelectorAll('.lp-chip');

  let selectedTopic = '';
  let selectedMood = '';

  // チップ選択
  chips.forEach(chip => {
    chip.addEventListener('click', () => {
      // チップの選択状態を視覚的に表現(任意)
      chips.forEach(c => c.classList.remove('active'));
      chip.classList.add('active');
      
      selectedTopic = chip.dataset.topic;
      topicInput.value = selectedTopic;
      checkFormComplete();
    });
  });

  // テキストエリア入力
  topicInput.addEventListener('input', (e) => {
    selectedTopic = e.target.value.trim();
    // 入力時はチップの選択を解除
    chips.forEach(c => c.classList.remove('active'));
    checkFormComplete();
  });

  // 気分選択
  moodBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      moodBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      selectedMood = btn.dataset.mood;
      checkFormComplete();
    });
  });

  // フォーム完了チェック
  function checkFormComplete() {
    if (selectedTopic && selectedMood) {
      runBtn.disabled = false;
      runBtn.classList.add('enabled'); // スタイル用のクラス(任意)
    } else {
      runBtn.disabled = true;
      runBtn.classList.remove('enabled');
    }
  }

  // 実行ボタン
  runBtn.addEventListener('click', () => {
    // ローディング演出
    runBtn.textContent = '考え中...';
    runBtn.disabled = true;

    // 少し遅延させてリアルな感じに
    setTimeout(() => {
      const result = generateDemoResult(selectedTopic, selectedMood);
      resultStep.textContent = result.step;
      resultNote.textContent = result.note;
      resultArea.style.display = 'block';
      
      // 結果までスムーズにスクロール
      resultArea.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      
      // ボタンを元に戻す
      runBtn.textContent = '今日の一歩を決める';
      runBtn.disabled = false;
    }, 800); // 0.8秒の遅延
  });

  // デモ用の結果生成
  function generateDemoResult(topic, mood) {
    // トピックと気分に応じた固定の回答
    const results = {
      '料理を始めてみたい': {
        light: { 
          step: '料理レシピ動画を1本見る', 
          note: 'まずは眺めるだけでOK。「作れそう」と思えるものを探してみよう。' 
        },
        medium: { 
          step: '冷蔵庫の中身を確認する', 
          note: '今ある材料で何が作れそうか、想像してみましょう。' 
        },
        heavy: { 
          step: 'お気に入りの料理系YouTuberを1人見つける', 
          note: '作らなくてもOK。見ているだけで楽しい人を探そう。' 
        },
        moody: { 
          step: '好きな食べ物を3つ書き出す', 
          note: 'なぜ好きなのか、少し考えてみると面白いかも。' 
        }
      },
      '英語を話せるようになりたい': {
        light: { 
          step: '英語の歌を1曲聴いてみる', 
          note: '意味が分からなくても大丈夫。音に慣れることから始めよう。' 
        },
        medium: { 
          step: '好きな英単語を3つ調べる', 
          note: '興味のある分野の単語から始めると楽しいですよ。' 
        },
        heavy: { 
          step: '英語学習アプリを1つダウンロードする', 
          note: '使わなくてもOK。まずは入れるだけでも一歩です。' 
        },
        moody: { 
          step: '英語を話せたら何をしたいか書き出す', 
          note: '目標が見えると、やる気が湧いてくるかも。' 
        }
      },
      'ランニングを習慣にしたい': {
        light: { 
          step: 'ランニングシューズを眺める', 
          note: '持っていなければ、ネットで見るだけでもOK。' 
        },
        medium: { 
          step: '外に出て5分だけ歩いてみる', 
          note: '走らなくてもOK。外の空気を吸うだけでも十分です。' 
        },
        heavy: { 
          step: 'ランニングウェアを着てみる', 
          note: '走らなくてもOK。まずは形から入ってみよう。' 
        },
        moody: { 
          step: 'ランニングを習慣にしたい理由を考える', 
          note: '「なぜやりたいのか」を整理すると、気持ちが楽になるかも。' 
        }
      },
      'イラストを描いてみたい': {
        light: { 
          step: '好きなイラストレーターを1人見つける', 
          note: 'SNSで検索してみると、素敵な作品に出会えるかも。' 
        },
        medium: { 
          step: '紙とペンを用意する', 
          note: '描かなくてもOK。まずは道具を揃えてみよう。' 
        },
        heavy: { 
          step: 'お絵描きアプリを1つダウンロードする', 
          note: '使わなくてもOK。まずは入れるだけでも一歩です。' 
        },
        moody: { 
          step: 'どんな絵を描きたいか想像してみる', 
          note: '描かなくてもOK。頭の中で想像するだけでも楽しいですよ。' 
        }
      }
    };

    // デフォルトの回答(トピックが一致しない場合)
    const defaultResults = {
      light: { 
        step: `「${topic}」について5分だけ調べてみる`, 
        note: '完璧を目指さず、まずは情報に触れるだけでOK。' 
      },
      medium: { 
        step: `「${topic}」の最初の一歩を書き出す`, 
        note: '何から始めればいいか、メモに書いてみましょう。' 
      },
      heavy: { 
        step: `「${topic}」について誰かに話してみる`, 
        note: '話すことで、自分の気持ちが整理されることも。' 
      },
      moody: { 
        step: `「${topic}」をやりたい理由を考えてみる`, 
        note: 'なぜやりたいのか、少し立ち止まって考えてみよう。' 
      }
    };

    // トピックに応じた結果を返す(なければデフォルト)
    return results[topic]?.[mood] || defaultResults[mood];
  }
};

// 初期化
document.addEventListener("DOMContentLoaded", initLpDemo);
document.addEventListener("turbo:load", initLpDemo);