require 'prawn'
class TravelController < ApplicationController
  layout nil , :only => [:get_zayavka, :get_dogovor]
  auto_complete_for :tourist, :surname_kir, :limit => 15, :order => 'surname_kir  DESC'

  def index
    @travels_grid = initialize_grid(Travel,
                                   :order => 'created_at',
                                   :order_direction => 'desc',
                                   :per_page => 20,
                                   :include => [:user, :tourist])
  end

  def new
  end

  def edit
    @travel = Travel.find(params[:id])
  end

  def select_tourist
    params[:travel].each do |key, varr|
      if key =~ /surname_kir.*/
      @tourist = Tourist.find(:all,:conditions => [ 'LOWER(surname_kir) LIKE ?','%' + varr.downcase + '%' ], :limit => 15, :order => 'surname_kir ' )
        @tourist.each {|x| x.surname_kir = x.surname_kir.to_s + " " + x.name_kir }
      render :inline => "<%= auto_complete_result(@tourist, 'surname_kir') %>"
      end
    end
  end

   def save
     # список туристов - без главного(платящего)
     if params['travel']['surname_kir'].empty?
       flash[:error] = "А где плательщик ?"
       redirect_to :action => 'index'
     else
        
     # FIXME необходимо подправить используя nested из 2.3.2
     @travelpoint_hash = Hash.new

       params['travel'].each do |key,val|
         if key =~ /^surname_kir\d+$/ and val != ""
           @alltourists ? @alltourists += ',' : @alltourists = ""
           @alltourists += Tourist.find(:first, :conditions => ['surname_kir = ? and name_kir = ?',val.split(' ')[0], val.split(' ')[1]]).id.to_s # тут вставляются имена туристов которые едут кроме плательщика
         end
         if key =~ /^travelpoint\d+$/ and val['country_id'] != "" and val['city_id'] != "" and val['hotel_id'] != ""
           @travelpoint_hash[key] = val
         end
       end

        @pay_tourist_id = Tourist.find_by_surname_kir(params['travel']['surname_kir'].split(' ')[0]).id
        params[:id] =~ /^\d+$/ ? @travel = Travel.find_by_id(params[:id]) : @travel = Travel.new

        { :pay_tourist_id => @pay_tourist_id,
          :tourists_array => @alltourists,
#          :travelpoint_attributes => @travelpoint_hash,
          :user_id => session[:user],
          :predoplata => params['travel']['predoplata'],
          :predoplata_type => params['travel']['predoplata_type'],
          :doplata => params['travel']['doplata'],
          :doplata_type => params['travel']['doplata_type'],
          :cena => params['travel']['cena'],
          :tyroperator_pay => params['travel']['tyroperator_pay']
        }.each do |key,val|
          @travel[key] = val
        end 
        
        if params['travel']['doplata'] =~ /^$/ or @travel.summa.to_i == @travel.cena.to_i
          then
          @travel.save!
          @@id_tp = []
          @travel.travelpoint.each do |x|
            @@id_tp << x.id.to_i
          end
          @@id = []
          @travelpoint_hash.each do |key,val|
            val['travel_id'] = @travel.id
            
            if val['id'].to_i > 0 
              Travelpoint.update(val['id'],val)
              @@id << val['id'].to_i 
            else 
              @@id << Travelpoint.create(val) 
            end
          end
          
          @@del_id = @@id_tp - @@id
          @@del_id.each do |iddel|
            Travelpoint.delete(iddel)
          end
        else
          flash[:error] = "Сумма всех выплат не совпадает с ценой"
        end
        redirect_to :controller => 'travel', :action => 'index'
     end
   end

   def remove_tourist
     render :update do |page|
       page.replace_html "tourist_input_#{params[:id]}"
     end
   end

   def save_podtv
     @podtv = Attachment.new
     @podtv.uploaded_file = params[:file][:uploaded_data]
     @podtv.travel_id = params[:id]
     if @podtv.save
       @travel = Travel.update(params[:id],{ :podtv => @podtv.id })
       flash[:notice] = "Подтверждение оплаты сохранено"
     else
       flash[:error] = "Ошибка! подтверждение не сохранено!"
     end
     redirect_to :back
   end

   def save_s4et
     @podtv = Attachment.new
     @podtv.uploaded_file = params[:file][:uploaded_data]
     @podtv.travel_id = params[:id]
     if @podtv.save
       @travel = Travel.update(params[:id],{ :s4et => @podtv.id })
       flash[:notice] = "Подтверждение оплаты сохранено"
#       render :partial => 'travel/link_s4et'
     else
       flash[:error] = "Ошибка! подтверждение не сохранено!"
     end
     redirect_to :back
   end

   def save_plat
       @platezhka = Attachment.new
       @platezhka.uploaded_file = params[:file][:uploaded_data]
       @platezhka.travel_id = params[:id]
       if @platezhka.save!
         Travel.update(params[:id],{ :platezhka => @platezhka.id })
        flash[:notice] = "Платежка сохранена" 
#         render :file => 'travel/_link_platezhka.html.erb'
       else
         render :text => "Ошибка! платежка не сохранена!"
       end        
       redirect_to :back
   end

   def remove_podtv
     @travel = Travel.find(params[:id])
     Attachment.delete(@travel.podtv)
     @travel.podtv = nil
     @travel.save!
     redirect_to :back
   end

   def remove_s4et
     @travel = Travel.find(params[:id])
     Attachment.delete(@travel.s4et)
     @travel.s4et = nil
     @travel.save!
     redirect_to :back
   end

   def remove_platezhka
     @travel = Travel.find(params[:id])
     Attachment.delete(@travel.platezhka)
     @travel.platezhka = nil
     @travel.save!
     redirect_to :back
   end


   def get_file
     @attachment = Attachment.find(params[:id])
     send_data @attachment.data, :filename => @attachment.name, :type => @attachment.content_type
   end


   def summ # отчеты


   end

   def get_ot4
     if params['date']['month'] =~ /^\d$/ 
       params['date']['month'] = '0' + params['date']['month']
     end
     @@date1 = '01-' + params['date']['month'] + '-' + params['date']['year']
     @@date2 = '30-' + params['date']['month'] + '-' + params['date']['year']
     #params[:ot4][:user_id]
     unless params['ot4']['user_id'].empty?
       @@user_q = "t.user_id = #{params['ot4']['user_id']} and "
     else
       @@user_q = ''
     end

     @tid = Travel.find_by_sql("select t.id,t.cena,t.tyroperator_pay from travels t,travelpoints tp where #{@@user_q} t.id = tp.travel_id and date_part('month', tp.date_start) = #{params['date']['month']} and date_part('year', tp.date_start) = #{params['date']['year']}") # запрос ищет по месяцу и году и пользователю - специфичен для postgresql
     @travels = initialize_grid(Travel,
                                :conditions => ['id = ?', @tid.collect {|x| x.id }],
                                :include => :user)
     @summa = 0
     @tid.each {|x| @summa += (x.cena - x.tyroperator_pay) }

   end

   def find_by_tourist
     # {"commit"=>"Найти", "authenticity_token"=>"YrzTZ/ItHfJTRcXV9PldA8Z6VJe9b4XZDzliiFuzFj0=", "travel"=>{"surname_kir"=>"surname_kir_49 name_kir_49"}}
     
     @tourist = Tourist.find(:all, :conditions => ['surname_kir =? and name_kir = ?',  params['travel']['surname_kir'].split(' ')[0] , params['travel']['surname_kir'].split(' ')[1]])
     @travels_grid = initialize_grid(Travel, 
                               :conditions => ['tourists_array like ?', @tourist.collect {|x| '%' + x.id.to_s + '%' }],
                               :order => 'created_at',
                               :order_direction => 'desc',
                               :per_page => 20,
                               :include => [:user, :tourist])
     render :layout => 'menu',:file => 'travel/index.html.erb'
   end

   def get_dogovor
     @travel = Travel.find(params[:id])
     @month = month_now
     #render :partial => 'travel/template_dogovor'

     pdf = Prawn::Document.new( :size => "A4", :page_layout => :portrait, :right_margin => 0.2 )
     pdf.font("#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf")
     pdf.text render :partial => 'travel/template_dogovor'
     pdf.render_file("public/dogovor_#{@travel.id}.pdf")
     send_file "public/dogovor_#{@travel.id}.pdf"

   end

   def get_zayavka
     @travel = Travel.find(params[:id])
    render :partial => 'travel/template_zayavka', :layout => nil 

   end
end
