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

  describe 'GET /tasks/report' do
    let(:genre) { Genre.create(name: 'テストジャンル') }

    context 'when there are no tasks' do
      it 'returns zero counts and completion rate' do
        get '/tasks/report'

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(%r{application/json})

        json_response = response.parsed_body
        expect(json_response['totalCount']).to eq(0)
        expect(json_response['countByStatus']['notStarted']).to eq(0)
        expect(json_response['countByStatus']['inProgress']).to eq(0)
        expect(json_response['countByStatus']['completed']).to eq(0)
        expect(json_response['completionRate']).to eq(0.0)
      end
    end

    context 'when there are tasks with various statuses' do
      before do
        # not_started: 2, in_progress: 3, completed: 1
        Task.create(name: 'Task 1', status: 'not_started', genre: genre)
        Task.create(name: 'Task 2', status: 'not_started', genre: genre)
        Task.create(name: 'Task 3', status: 'in_progress', genre: genre)
        Task.create(name: 'Task 4', status: 'in_progress', genre: genre)
        Task.create(name: 'Task 5', status: 'in_progress', genre: genre)
        Task.create(name: 'Task 6', status: 'completed', genre: genre)
      end

      it 'returns correct total count' do
        get '/tasks/report'

        expect(response).to have_http_status(:ok)
        json_response = response.parsed_body
        expect(json_response['totalCount']).to eq(6)
      end

      it 'returns correct count by status' do
        get '/tasks/report'

        json_response = response.parsed_body
        expect(json_response['countByStatus']['notStarted']).to eq(2)
        expect(json_response['countByStatus']['inProgress']).to eq(3)
        expect(json_response['countByStatus']['completed']).to eq(1)
      end

      it 'returns completion rate with one decimal place' do
        get '/tasks/report'

        json_response = response.parsed_body
        # 1 completed / 6 total = 16.666... -> 16.7
        expect(json_response['completionRate']).to eq(16.7)
      end
    end

    context 'when all tasks are completed' do
      before do
        Task.create(name: 'Task 1', status: 'completed', genre: genre)
        Task.create(name: 'Task 2', status: 'completed', genre: genre)
      end

      it 'returns 100% completion rate' do
        get '/tasks/report'

        json_response = response.parsed_body
        expect(json_response['totalCount']).to eq(2)
        expect(json_response['completionRate']).to eq(100.0)
      end
    end
  end
end
