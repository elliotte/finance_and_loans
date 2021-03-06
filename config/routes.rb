Draftapp::Application.routes.draw do

  root :to => "welcome#index"
  
  get 'authorize' => 'welcome#connect'
  get 'get_token' => 'welcome#connect'

  post '/oauth/token'=>'welcome#connect'
  resources :welcome, :only => [:index] do
    collection do
      post :connect
      post :disconnect
      get :sign_out_user
      get :auth_landing
    end
  end

  resources :ledgers do
    put :share, on: :member
    put :vat_csv, on: :member
    put :vat_to_google, on: :member
    #  collection do
    #   #get :last_user_ledgers
    # end
  end

  resources :transactions do
    put :update_transaction_controlled, on: :member
    put :invoice_paid, on: :member
    put :update_invoice_file_paid, on: :member
  end

  resources :cash_ledgers, only: [:show, :new] do
    post :user_csv_import, on: :collection
    post :book_single_trn, on: :member
    get :add_to, on: :member
    get :add_payments, on: :member
    get :manual_filter, on: :member
    get :order_filter, on: :member
    get :add_lodgements, on: :member
    get :transactions_for, on: :member
    get :ledger_manager, on: :member
    get :trial_balance, on: :member
    get :new_google_export, on: :member
    post :export_tb_google, on: :member
    post :export_gl_google, on: :member
    post :export_transactons, on: :member
    get :import_csv, on: :member
    get :next_transactions, on: :member
  end

  resources :purchase_ledgers, :cash_flow_ledgers, :sales_ledgers, only: [:show] do 
    member do 
      get :transactions_for
      post :to_ss_export
    end
  end

  resources :cash_flow_ledgers do
    member do 
      get :fetch_cf_data_input_form
      get :edit_cf_settings
      post :update_drivers
      post :update_cf_settings
      post :add_transactions
      get :export_transactions_to_csv
    end
  end

  resources :reports do
    get :autocomplete_friends_list, :on => :collection
    get :autocomplete_google_list, :on => :collection
    get :download_data_as_csv_file,:on => :collection
    post :export_dash_o365,:on => :member
    put :share, on: :member
    resources :values, only: [:new, :create, :destroy]
    resources :disclosures do
      get :manager, on: :collection
      get :export_current, on: :collection
      get :export_all, on: :collection
    end
    resources :notes do
      get :manager, on: :collection
      get :export_current, on: :collection
      get :export_all, on: :collection
      get :get_notes,on: :collection
    end
    resources :comments do
      get :manager, on: :collection
      get :export_current, on: :collection
      get :export_all, on: :collection
      get :get_comments,on: :collection
    end
    get :report_manager, on: :member
    get :import_csv, on: :member
    #below to member?
    post :user_csv_import, on: :collection
    #below to member?
    get :new_value, on: :collection
    post :add_value, on: :member
    put :update_value, on: :member

    get :new_journal, on: :member
    post :save_journal, on: :member

    get :show_dashboard, on: :member
    post :export_dash, on: :member
    get :export_form, on: :member
    post :to_google_export, on: :member
    get :last_user_reports, on: :collection
    get :get_comments, on: :member
    get :get_notes, on: :member
    get :get_breakdown_values, on: :member
    delete :delete_value,on: :member
    get :show_readers,on: :member
  end

  # resources :files, only:[:index] do
  #   collection do
  #     post :delete_file
  #     put :new_document
  #     put :new_spreadsheet
  #   end
  # end


end
