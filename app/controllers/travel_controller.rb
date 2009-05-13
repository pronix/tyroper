class TravelController < ApplicationController
  auto_complete_for :tourist, :surname_kir

  def index
    @travels_grid = initialize_grid(Travel,
                                   :order => 'created_at',
                                   :order_direction => 'desc',
                                   :per_page => 20)
  end

  def new
  end

  def edit
    @travel = Travel.find(params[:id])
  end

  def select_tourist
    params[:travel].each do |key, varr|
      if key =~ /surname_kir.*/
      @tourist = Tourist.find(:all,:conditions => [ 'LOWER(surname_kir) LIKE ?','%' + varr.downcase + '%' ])
      render :inline => "<%= auto_complete_result(@tourist, 'surname_kir') %>"
      end
    end
  end

   def save
     # список туристов - без главного(платящего)
     if params['travel']['surname_kir'].empty?
       flash[:error] = "А где плательщик ?"
       redirect_to :action => 'index'
     end
       
       params['travel'].each do |key,val|
         if key =~ /^surname_kir\d+$/ and val != ""
           @alltourists ? @alltourists += ',' : @alltourists = ""
           @alltourists += val
         end
       end
       
       
       # список отелей в которых остановятся по пути
        @travelpoint_hash = Hash.new
        params['travel'].each do |key,val|
          if key =~ /^travelpoint\d+$/ and val['country_id'] != "" and val['city_id'] != "" and val['hotel_id'] != ""
            @travelpoint_hash[key] = val
          end
        end
       
        @pay_tourist_id = Tourist.find_by_surname_kir(params['travel']['surname_kir']).id
        params[:id] =~ /^\d+$/ ? @travel = Travel.find_by_id(params[:id]) : @travel = Travel.new

        { :pay_tourist_id => @pay_tourist_id,
          :tourists_array => @alltourists,
          :travelpoint_attributes => @travelpoint_hash,
          :user_id => session[:user],
          :predoplata => params['travel']['predoplata'],
          :predoplata_type => params['travel']['predoplata_type'],
          :doplata => params['travel']['doplata'],
          :doplata_type => params['travel']['doplata_type']
        }.each do |key,val|
          @travel[key] = val
        end

if params['travel']['doplata'] =~ /^$/ or @travel.summa.to_i == @travel.cena.to_i
  then



  @travel.save!
  # сохраняем файл
  #
  #
  #
   unless params[:platezhka].blank?
   @platezhka = Attachment.new
   @platezhka.uploaded_file = params[:platezhka]
   @platezhka.travel_id = @travel.id
   if @platezhka.save!
     Travel.update(@travel.id,{ :platezhka => @platezhka.id })
     flash[:notice] = "Платежка сохранена успешно"
   else
     flash[:error] = "Ошибка! платежка не сохранена!"
   end        
   end
   



   unless params[:podtverzhd].blank?
     @podtv = Attachment.new
     @podtv.uploaded_file = params[:podtverzhd]
     @podtv.travel_id = @travel.id

     if @podtv.save
       Travel.update(@travel.id,{ :podtv => @podtv.id })
       flash[:notice] = "Подтверждение оплаты сохранено"
     else
       flash[:error] = "Ошибка! подтверждение не сохранено!"
     end
   end



else
  flash[:error] = "Сумма всех выплат не совпадает с ценой"
end
   redirect_to :controller => 'travel', :action => 'index'
   end

   def get_file
     @attachment = Attachment.find(params[:id])
     send_data @attachment.data, :filename => @attachment.name, :type => @attachment.content_type
#     redirect_to :back
   end


   def summ # отчеты
   end
end
