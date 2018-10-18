module Admin
  module Accounts
    class NotesController < Admin::Accounts::ApplicationController
      decorates_assigned :notes

      power :admin_account_notes, context: :load_account, as: :notes_scope

      def index
        @notes = notes_scope.sorted.includes(:user)

        @note = notes_scope.new(user: current_user)
      end

      def new
        @note = notes_scope.new(user: current_user)
      end

      def create
        @note = notes_scope.new(note_params.merge(user: current_user))

        if @note.save
          respond_to do |format|
            format.html do
              flash[:notice] = 'The note has been added.'
              redirect_to [:admin, @account, :notes]
            end
            format.js do
              @notes = notes_scope.sorted.includes(:user)
              @note = notes_scope.new(user: current_user)
              render :index
            end
          end
        else
          render :new
        end
      end

      def destroy
        notes_scope.find(params[:id]).destroy

        respond_to do |format|
          format.html do
            flash[:notice] = 'The note has been removed.'
            redirect_to [:admin, @account, :notes]
          end
          format.js do
            @notes = notes_scope.sorted.includes(:user)
            @note = notes_scope.new(user: current_user)
            render :index
          end
        end
      end

      private
      def note_params
        params.require(:note).permit(:body)
      end
    end
  end
end