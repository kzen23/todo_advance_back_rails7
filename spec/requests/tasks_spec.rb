require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  let(:genre) { Genre.create(name: 'テストジャンル') }

  describe 'POST /tasks' do
    context 'when priority parameter is specified' do
      it 'creates a task with the specified priority' do
        post '/tasks', params: {
          name: '優先度付きタスク',
          explanation: 'テスト説明',
          priority: 'high',
          genreId: genre.id,
          deadlineDate: '2026-12-31'
        }

        expect(response).to have_http_status(:ok)

        # データベースにタスクが作成されていることを確認
        task = Task.last
        expect(task.name).to eq('優先度付きタスク')
        expect(task.priority).to eq('high')
      end

      it 'returns JSON response including priority' do
        post '/tasks', params: {
          name: '優先度付きタスク',
          priority: 'low',
          genreId: genre.id
        }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(%r{application/json})

        json_response = response.parsed_body
        created_task = json_response.find { |task| task['name'] == '優先度付きタスク' }

        expect(created_task).not_to be_nil
        expect(created_task['priority']).to eq('low')
      end
    end

    context 'when priority parameter is not specified' do
      it 'creates a task with default priority (medium)' do
        post '/tasks', params: {
          name: 'デフォルト優先度タスク',
          genreId: genre.id
        }

        expect(response).to have_http_status(:ok)

        task = Task.last
        expect(task.name).to eq('デフォルト優先度タスク')
        expect(task.priority).to eq('medium')
      end

      it 'returns JSON response with medium priority' do
        post '/tasks', params: {
          name: 'デフォルト優先度タスク',
          genreId: genre.id
        }

        json_response = response.parsed_body
        created_task = json_response.find { |task| task['name'] == 'デフォルト優先度タスク' }

        expect(created_task['priority']).to eq('medium')
      end
    end

    context 'when priority has different values' do
      it 'accepts low priority' do
        post '/tasks', params: { name: '低', priority: 'low', genreId: genre.id }
        expect(Task.last.priority).to eq('low')
      end

      it 'accepts medium priority' do
        post '/tasks', params: { name: '中', priority: 'medium', genreId: genre.id }
        expect(Task.last.priority).to eq('medium')
      end

      it 'accepts high priority' do
        post '/tasks', params: { name: '高', priority: 'high', genreId: genre.id }
        expect(Task.last.priority).to eq('high')
      end
    end
  end

  describe 'GET /tasks' do
    it 'returns tasks with priority information' do
      Task.create(name: '低優先度', genre: genre, priority: :low)
      Task.create(name: '中優先度', genre: genre, priority: :medium)
      Task.create(name: '高優先度', genre: genre, priority: :high)

      get '/tasks'

      expect(response).to have_http_status(:ok)

      json_response = response.parsed_body
      expect(json_response.length).to eq(3)

      low_task = json_response.find { |task| task['name'] == '低優先度' }
      medium_task = json_response.find { |task| task['name'] == '中優先度' }
      high_task = json_response.find { |task| task['name'] == '高優先度' }

      expect(low_task['priority']).to eq('low')
      expect(medium_task['priority']).to eq('medium')
      expect(high_task['priority']).to eq('high')
    end
  end

  describe 'POST /tasks/:id/duplicate' do
    let(:original_task) do
      Task.create(
        name: '元のタスク',
        explanation: '元の説明文',
        genre: genre,
        priority: :high,
        status: :completed,
        deadline_date: Time.zone.today + 7
      )
    end

    context '正常系' do
      it 'ステータスコード 201 Created が返る' do
        post "/tasks/#{original_task.id}/duplicate"
        expect(response).to have_http_status(:created)
      end

      it 'レスポンスが正しいJSON形式で返る' do
        post "/tasks/#{original_task.id}/duplicate"
        expect(response.content_type).to match(%r{application/json})
        expect { response.parsed_body }.not_to raise_error
      end

      it '複製されたタスクがレスポンスに含まれる' do
        post "/tasks/#{original_task.id}/duplicate"
        json_response = response.parsed_body

        expect(json_response).to have_key('id')
        expect(json_response).to have_key('name')
        expect(json_response['id']).not_to eq(original_task.id)
      end

      it 'データベースのタスク数が1つ増加する' do
        task = original_task
        expect do
          post "/tasks/#{task.id}/duplicate"
        end.to change(Task, :count).by(1)
      end

      it '元のタスクが変更されない' do
        original_attributes = original_task.attributes
        post "/tasks/#{original_task.id}/duplicate"
        original_task.reload

        expect(original_task.attributes).to eq(original_attributes)
      end
    end

    context '異常系' do
      it '存在しないタスクIDで404 Not Foundが返る' do
        non_existent_id = Task.maximum(:id).to_i + 1000

        post "/tasks/#{non_existent_id}/duplicate"
        expect(response).to have_http_status(:not_found)
      end

      it 'エラー時のレスポンスにエラーメッセージが含まれる' do
        non_existent_id = Task.maximum(:id).to_i + 1000

        post "/tasks/#{non_existent_id}/duplicate"
        json_response = response.parsed_body

        expect(json_response).to have_key('error')
        expect(json_response['error']).to be_present
      end
    end
  end
end
