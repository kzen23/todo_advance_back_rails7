require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:genre) { Genre.create(name: 'テストジャンル') }

  describe 'priority enum' do
    it 'has valid priority values (low, medium, high)' do
      expect(Task.priorities.keys).to match_array(%w[low medium high])
    end

    it 'allows setting priority to low' do
      task = Task.create(name: '低優先度タスク', genre: genre, priority: :low)
      expect(task.priority).to eq('low')
      expect(task.low?).to be true
    end

    it 'allows setting priority to medium' do
      task = Task.create(name: '中優先度タスク', genre: genre, priority: :medium)
      expect(task.priority).to eq('medium')
      expect(task.medium?).to be true
    end

    it 'allows setting priority to high' do
      task = Task.create(name: '高優先度タスク', genre: genre, priority: :high)
      expect(task.priority).to eq('high')
      expect(task.high?).to be true
    end
  end

  describe 'default priority' do
    it 'defaults to medium when priority is not specified' do
      task = Task.create(name: 'デフォルト優先度タスク', genre: genre)
      expect(task.priority).to eq('medium')
    end

    it 'has priority value of 1 (medium) in database' do
      task = Task.create(name: 'デフォルト優先度タスク', genre: genre)
      expect(task.attributes_before_type_cast['priority']).to eq(1)
    end
  end

  describe 'status enum' do
    it 'has valid status values (not_started, in_progress, completed)' do
      expect(Task.statuses.keys).to match_array(%w[not_started in_progress completed])
    end

    it 'allows setting status to not_started' do
      task = Task.create(name: '未着手タスク', genre: genre, status: :not_started)
      expect(task.status).to eq('not_started')
      expect(task.not_started?).to be true
    end

    it 'allows setting status to in_progress' do
      task = Task.create(name: '進行中タスク', genre: genre, status: :in_progress)
      expect(task.status).to eq('in_progress')
      expect(task.in_progress?).to be true
    end

    it 'allows setting status to completed' do
      task = Task.create(name: '完了タスク', genre: genre, status: :completed)
      expect(task.status).to eq('completed')
      expect(task.completed?).to be true
    end
  end

  describe 'default status' do
    it 'defaults to not_started when status is not specified' do
      task = Task.create(name: 'デフォルトステータスタスク', genre: genre)
      expect(task.status).to eq('not_started')
    end

    it 'has status value of 0 (not_started) in database' do
      task = Task.create(name: 'デフォルトステータスタスク', genre: genre)
      expect(task.attributes_before_type_cast['status']).to eq(0)
    end
  end
end
