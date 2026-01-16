require 'rails_helper'

RSpec.describe Tasks::DuplicateService do
  let(:genre) { Genre.create(name: 'テストジャンル') }

  describe '.call' do
    context '正常系 - 基本動作' do
      let(:original_task) do
        Task.create(
          name: '元のタスク',
          explanation: '元の説明文',
          genre: genre,
          priority: :medium,
          status: :in_progress,
          deadline_date: Time.zone.today + 7
        )
      end

      it '新しいTaskインスタンスが作成される' do
        task = original_task
        expect do
          Tasks::DuplicateService.call(task)
        end.to change(Task, :count).by(1)
      end

      it '元のnameの末尾に「(コピー)」が追加される' do
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.name).to eq('元のタスク(コピー)')
      end

      it '元のexplanationがそのまま引き継がれる' do
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.explanation).to eq(original_task.explanation)
      end

      it '元のgenre_idがそのまま引き継がれる' do
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.genre_id).to eq(original_task.genre_id)
      end

      it '元のpriorityがそのまま引き継がれる' do
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.priority).to eq(original_task.priority)
      end

      it '元のstatusに関わらず、未着手（初期値）になる' do
        original_task.update(status: :completed)
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.status).to eq('not_started')
      end

      it '元のdeadline_dateに関わらず、nilになる' do
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.deadline_date).to be_nil
      end

      it '複製時の日時が新しく設定される（元と異なる）' do
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.created_at).not_to eq(original_task.created_at)
        expect(duplicated_task.created_at).to be > original_task.created_at
      end

      it '元のタスクとは異なる新しいidが割り振られる' do
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.id).not_to eq(original_task.id)
        expect(duplicated_task.id).to be > original_task.id
      end
    end

    context 'エッジケース - name属性' do
      it '既に「(コピー)」を含むnameを複製すると「(コピー)(コピー)」となる' do
        original_task = Task.create(
          name: 'タスク名(コピー)',
          genre: genre
        )
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.name).to eq('タスク名(コピー)(コピー)')
      end

      it '空文字のnameを複製すると「(コピー)」のみになる' do
        original_task = Task.create(
          name: '',
          genre: genre
        )
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.name).to eq('(コピー)')
      end

      it '非常に長いnameを複製しても正しく処理される' do
        long_name = 'あ' * 200
        original_task = Task.create(
          name: long_name,
          genre: genre
        )
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.name).to eq("#{long_name}(コピー)")
      end

      it '特殊文字を含むnameを複製しても正しく保持される' do
        special_name = 'タスク 🎉 & <test> "引用符"'
        original_task = Task.create(
          name: special_name,
          genre: genre
        )
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.name).to eq("#{special_name}(コピー)")
      end
    end

    context 'エッジケース - その他の属性' do
      it 'explanationがnilの場合、nilのまま引き継がれる' do
        original_task = Task.create(
          name: 'タスク',
          explanation: nil,
          genre: genre
        )
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.explanation).to be_nil
      end

      it 'explanationが空文字の場合、空文字のまま引き継がれる' do
        original_task = Task.create(
          name: 'タスク',
          explanation: '',
          genre: genre
        )
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.explanation).to eq('')
      end

      it 'genre_idが存在する場合、正しく関連付けが引き継がれる' do
        original_task = Task.create(
          name: 'タスク',
          genre: genre
        )
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.genre).to eq(original_task.genre)
        expect(duplicated_task.genre_id).to eq(original_task.genre_id)
      end

      it 'priorityがlowの場合、lowのまま引き継がれる' do
        original_task = Task.create(
          name: 'タスク',
          genre: genre,
          priority: :low
        )
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.priority).to eq('low')
        expect(duplicated_task.low?).to be true
      end

      it 'priorityがmediumの場合、mediumのまま引き継がれる' do
        original_task = Task.create(
          name: 'タスク',
          genre: genre,
          priority: :medium
        )
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.priority).to eq('medium')
        expect(duplicated_task.medium?).to be true
      end

      it 'priorityがhighの場合、highのまま引き継がれる' do
        original_task = Task.create(
          name: 'タスク',
          genre: genre,
          priority: :high
        )
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.priority).to eq('high')
        expect(duplicated_task.high?).to be true
      end

      it 'deadline_dateが設定済みの場合、nilにリセットされる' do
        original_task = Task.create(
          name: 'タスク',
          genre: genre,
          deadline_date: Time.zone.today + 10
        )
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.deadline_date).to be_nil
      end

      it 'deadline_dateがnilの場合、nilのまま維持される' do
        original_task = Task.create(
          name: 'タスク',
          genre: genre,
          deadline_date: nil
        )
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.deadline_date).to be_nil
      end

      it 'statusが完了済みの場合、未着手にリセットされる' do
        original_task = Task.create(
          name: 'タスク',
          genre: genre,
          status: :completed
        )
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.status).to eq('not_started')
      end
    end

    context 'バリデーション' do
      let(:original_task) do
        Task.create(
          name: '元のタスク',
          explanation: '説明文',
          genre: genre,
          priority: :medium
        )
      end

      it '複製後のタスクが有効である' do
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.valid?).to be true
      end

      it '複製後のタスクが保存可能である' do
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.persisted?).to be true
      end

      it '必要な属性がすべて設定されている' do
        duplicated_task = Tasks::DuplicateService.call(original_task).data
        expect(duplicated_task.name).to be_present
        expect(duplicated_task.genre_id).to be_present
        expect(duplicated_task.priority).to be_present
      end
    end
  end
end
