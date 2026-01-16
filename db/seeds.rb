tasks = [
  { name: '要件定義', explanation: 'クライアントに意見をヒアリングして、要件を決定します', deadline_date: '2020-12-30', status: 5, genre_id: 1 },
  { name: '基本設計', explanation: '機能や画面レイアウトについて決定します。', deadline_date: '2020-12-30', status: 5, genre_id: 1 },
  { name: '詳細設計', explanation: 'DB設計や必要なクラスやモジュールなどを決定します', deadline_date: '2020-12-30', status: 4, genre_id: 1 },
  { name: '実装', explanation: '設計に基づいてアプリケーションの作成をします。', deadline_date: '2020-12-30', status: 3, genre_id: 1 },
  { name: '単体テスト', explanation: '作成したプログラム単体の動作を確認します', deadline_date: '2020-12-30', status: 2, genre_id: 1 },
  { name: '結合テスト', explanation: '複数プログラムを組み合わせた場合の動作を確認します', deadline_date: '2025-12-30', status: 4, genre_id: 1 },
  { name: '総合テスト', explanation: 'システム全体を通した動作を確認します', deadline_date: '2025-12-30', status: 1, genre_id: 1 },
  { name: '受入テスト', explanation: '本番環境に適用した際の動作を確認します', deadline_date: '2025-12-30', status: 0, genre_id: 1 },
  { name: '納品', explanation: 'お客様に納品します', deadline_date: '2025-12-30', status: 0, genre_id: 1 },
  { name: 'サンプルデータA', explanation: '作成したアプリをチェックします。', deadline_date: '2020-12-30', status: 1, genre_id: 2  },
  { name: 'サンプルデータB', explanation: '作成したアプリをチェックします。', deadline_date: '2020-12-30', status: 1, genre_id: 2  },
  { name: 'サンプルデータC', explanation: '作成したアプリをチェックします。', deadline_date: '2020-12-30', status: 2, genre_id: 2  },
  { name: 'サンプルデータD', explanation: '作成したアプリをチェックします。', deadline_date: '2020-12-30', status: 3, genre_id: 2  },
  { name: 'サンプルデータE', explanation: '作成したアプリをチェックします。', deadline_date: '2020-12-30', status: 4, genre_id: 2  },
  { name: 'サンプルデータF', explanation: '作成したアプリをチェックします。', deadline_date: '2020-12-30', status: 5, genre_id: 2  },
  { name: 'サンプルデータG', explanation: '作成したアプリをチェックします。', deadline_date: '2020-12-30', status: 1, genre_id: 2  },
  { name: 'サンプルデータH', explanation: '作成したアプリをチェックします。', deadline_date: '2020-12-30', status: 5, genre_id: 2  },
  { name: 'サンプルデータI', explanation: '作成したアプリをチェックします。', deadline_date: '2020-12-30', status: 2, genre_id: 2  },
  { name: 'サンプルデータJ', explanation: '作成したアプリをチェックします。', deadline_date: '2020-12-30', status: 4, genre_id: 3  },
  { name: 'サンプルデータK', explanation: '作成したアプリをチェックします。', deadline_date: '2020-12-30', status: 2, genre_id: 3  },
  { name: 'サンプルデータL', explanation: '作成したアプリをチェックします。', deadline_date: '2020-12-30', status: 2, genre_id: 3  },
  { name: 'サンプルデータM', explanation: '作成したアプリをチェックします。', deadline_date: '2025-12-30', status: 5, genre_id: 3  },
  { name: 'サンプルデータN', explanation: '作成したアプリをチェックします。', deadline_date: '2025-12-30', status: 2, genre_id: 3  },
  { name: 'サンプルデータO', explanation: '作成したアプリをチェックします。', deadline_date: '2025-12-30', status: 1, genre_id: 3  },
  { name: 'サンプルデータP', explanation: '作成したアプリをチェックします。', deadline_date: '2025-12-30', status: 1, genre_id: 3  },
  { name: 'サンプルデータQ', explanation: '作成したアプリをチェックします。', deadline_date: '2025-12-30', status: 2, genre_id: 3  },
  { name: 'サンプルデータR', explanation: '作成したアプリをチェックします。', deadline_date: '2025-12-30', status: 3, genre_id: 3  },
  { name: 'サンプルデータS', explanation: '作成したアプリをチェックします。', deadline_date: '2025-12-30', status: 4, genre_id: 4  },
  { name: 'サンプルデータT', explanation: '作成したアプリをチェックします。', deadline_date: '2025-12-30', status: 5, genre_id: 4  },
  { name: 'サンプルデータU', explanation: '作成したアプリをチェックします。', deadline_date: '2025-12-30', status: 1, genre_id: 4  },
  { name: 'サンプルデータV', explanation: '作成したアプリをチェックします。', deadline_date: '2025-12-30', status: 2, genre_id: 4  },
  { name: 'サンプルデータW', explanation: '作成したアプリをチェックします。', deadline_date: '2025-12-30', status: 4, genre_id: 4  },
  { name: 'サンプルデータX', explanation: '作成したアプリをチェックします。', deadline_date: '2025-12-30', status: 3, genre_id: 4  },
  { name: 'サンプルデータY', explanation: '作成したアプリをチェックします。', deadline_date: '2025-12-30', status: 5, genre_id: 4  },
  { name: 'サンプルデータZ', explanation: '作成したアプリをチェックします。', deadline_date: '2025-12-30', status: 3, genre_id: 4  }
]

genres = [
  { name: 'sample株式会社' },
  { name: 'test合同会社' },
  { name: 'tanaka有限会社' },
  { name: 'apple会社' }
]

ActiveRecord::Base.transaction do
  genres.each do |genre|
    Genre.create(genre)
  end
  tasks.each do |task|
    Task.create(task)
  end
end
