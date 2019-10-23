# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transactions::Relays::Update do
  subject(:result) { described_class.new.(input) }
  let(:input) { { user: user, params: ActionController::Parameters.new(params) } }
  let!(:user) { create(:user) }
  let(:matcher) {
    proc { |m|
      m.success do
        'success'
      end

      m.failure :validate do
        'validate'
      end

      m.failure :find_relay do
        'find_relay'
      end

      m.failure :policy do
        'policy'
      end

      m.failure :update do
        'update'
      end
    }
  }

  context 'valid params' do
    context 'missing relay' do
      subject(:operation) { described_class.new }

      let(:params) { { id: 1, relay: attributes_for(:relay) } }

      it { expect(operation.call(input, &matcher)).to eq('find_relay') }
    end

    context 'relay exists' do
      context 'user is not owner' do
        subject(:operation) { described_class.new }

        let!(:relay) { create(:relay) }
        let(:params) { { id: relay.id, relay: relay.attributes } }

        it { expect(operation.call(input, &matcher)).to eq('policy') }
      end

      context 'user is owner' do
        let!(:device) { create(:device, user: user) }
        let!(:relay) { create(:relay, device: device) }
        let(:params) { { id: relay.id, relay: relay.attributes.merge(name: 'updated') } }

        it { is_expected.to be_success }
        it { expect(result.success[:model]).to_not be_nil }
        it { expect { result }.to change { relay.reload.name }.to('updated') }

        context 'task is provided' do
          let(:task_attributes) { attributes_for(:task).merge(values_range: false) }
          let(:params) { { id: relay.id, relay: attributes_for(:relay).merge(task: task_attributes) } }

          it { expect { result }.to change { Task.count }.by(1) }

          context 'existing task' do
            let!(:task) { create(:task, min: 0, max: 100, relay: relay) }

            it { expect { result }.to change { task.reload.min }.to(nil) }
          end

          context 'task schedule is provided' do
            let(:days) { attributes_for(:task_schedule)[:days] }
            let(:task_attributes) { attributes_for(:task).merge(values_range: false, task_schedule: { schedule: 'none' }) }

            it { expect { result }.to change { TaskSchedule.count }.by(1) }

            context 'existing task schedule' do
              let!(:task) { create(:task, min: 0, max: 100, relay: relay) }
              let!(:task_schedule) { create(:task_schedule, task: task, start: DateTime.now, stop: DateTime.now + 1.day) }

              it { expect { result }.to change { task_schedule.reload.start }.to(nil) }
            end

            context 'no schedule' do
              let(:task_schedule_attributes) { { schedule: 'none', start: DateTime.now, stop: DateTime.now + 1.day, days: days.merge(mon: { on: 100, off: 200 }) } }
              let(:task_attributes) { attributes_for(:task).merge(values_range: false, task_schedule: task_schedule_attributes) }

              it { expect(result.success[:model].task.task_schedule.start).to be_nil }
              it { expect(result.success[:model].task.task_schedule.stop).to be_nil }
              it { expect(result.success[:model].task.task_schedule.days).to eq(attributes_for(:task_schedule)[:days].deep_stringify_keys) }
            end

            context 'calendar schedule' do
              let(:task_schedule_attributes) { { schedule: 'calendar', start: DateTime.now, stop: DateTime.now + 1.day, days: days.merge(mon: { on: 100, off: 200 }) } }
              let(:task_attributes) { attributes_for(:task).merge(values_range: false, task_schedule: task_schedule_attributes) }

              it { expect(result.success[:model].task.task_schedule.days).to eq(attributes_for(:task_schedule)[:days].deep_stringify_keys) }
            end

            context 'weekly schedule' do
              let(:task_schedule_attributes) { { schedule: 'weekly', start: DateTime.now, stop: DateTime.now + 1.day, days: days.merge(mon: { on: 100, off: 200 }) } }
              let(:task_attributes) { attributes_for(:task).merge(values_range: false, task_schedule: task_schedule_attributes) }

              it { expect(result.success[:model].task.task_schedule.start).to be_nil }
              it { expect(result.success[:model].task.task_schedule.stop).to be_nil }
            end
          end
        end
      end
    end
  end

  context 'invalid params' do
    context 'empty params' do
      let(:params) { {} }

      it { expect(subject.failure[:id]).to eq(['is missing']) }
    end

    context 'missing name' do
      let(:params) { { id: 1, relay: attributes_for(:relay).merge(name: '') } }

      it { expect(subject.failure[:relay][:name]).to eq(['must be filled']) }
    end

    context 'duplicate name' do
      let!(:relay) { create(:relay) }
      let!(:another_relay) { create(:relay, device: relay.device) }
      let(:params) { { id: relay.id, relay: attributes_for(:relay).merge(name: another_relay.name) } }

      it { expect(subject.failure[:relay][:name]).to eq(['must be unique']) }
    end

    context 'missing icon' do
      let(:params) { { id: 1, relay: attributes_for(:relay).merge(icon: '') } }

      it { expect(subject.failure[:relay][:icon]).to eq(['must be filled']) }
    end

    context 'wrong state' do
      let(:params) { { id: 1, relay: attributes_for(:relay).merge(state: 'aaa') } }

      it { expect(subject.failure[:relay][:state]).to eq(['must be one of: off, on, task_mode']) }
    end

    context 'with task data' do
      context 'missing values_range' do
        let(:params) { { id: 1, relay: attributes_for(:relay).merge(task: attributes_for(:task)) } }

        it { expect(subject.failure[:relay][:task][:values_range]).to eq(['is missing']) }
      end

      context 'only min is provided' do
        let(:task_attributes) { attributes_for(:task).merge(values_range: true, min: 0, max: nil) }
        let(:params) { { id: 1, relay: attributes_for(:relay).merge(task: task_attributes) } }

        it { expect(subject.failure[:relay][:task][:min]).to eq(['both min and max are required']) }
      end

      context 'with task_schedule data' do
        context 'wrong schedule' do
          let(:task_schedule_attributes) { attributes_for(:task_schedule).merge(schedule: 'aaa') }
          let(:task_attributes) { attributes_for(:task).merge(values_range: false, task_schedule: task_schedule_attributes) }
          let(:params) { { id: 1, relay: attributes_for(:relay).merge(task: task_attributes) } }

          it { expect(subject.failure[:relay][:task][:task_schedule][:schedule]).to eq(['must be one of: none, calendar, weekly']) }
        end

        context 'stop before start' do
          let(:task_schedule_attributes) { attributes_for(:task_schedule, stop: DateTime.now + 1.day, start: DateTime.now + 2.days).merge(schedule: 'calendar') }
          let(:task_attributes) { attributes_for(:task).merge(values_range: false, task_schedule: task_schedule_attributes) }
          let(:params) { { id: 1, relay: attributes_for(:relay).merge(task: task_attributes) } }

          it { expect(subject.failure[:relay][:task][:task_schedule][:start]).to eq(['start should be before stop']) }
        end

        context 'on before off' do
          let(:days) { { mon: { on: 200, off: 100 }, tue: { on: nil, off: nil }, wed: { on: nil, off: nil }, thu: { on: nil, off: nil }, fri: { on: nil, off: nil }, sat: { on: nil, off: nil }, sun: { on: nil, off: nil } } }
          let(:task_schedule_attributes) { attributes_for(:task_schedule, days: days).merge(schedule: 'weekly') }
          let(:task_attributes) { attributes_for(:task).merge(values_range: false, task_schedule: task_schedule_attributes) }
          let(:params) { { id: 1, relay: attributes_for(:relay).merge(task: task_attributes) } }

          it { expect(subject.failure[:relay][:task][:task_schedule][:days][:mon]).to eq(['on should be before off']) }
        end
      end
    end
  end
end
