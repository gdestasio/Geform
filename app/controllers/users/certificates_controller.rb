class Users::CertificatesController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!

	def index
		@certificates = current_user.certificates
	end

	def download
		certificate = Certificate.find(params[:id])
	  send_file "#{Rails.root}/private/certificates/#{certificate.user.id}/#{certificate.event.id}.pdf", :filename => certificate.event.name,
	      :type => "application/pdf", :x_sendfile => true
	end
end