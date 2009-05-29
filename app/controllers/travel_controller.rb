require 'rubygems'
require 'odf/spreadsheet'
class TravelController < ApplicationController
  before_filter :admin_required, :only => [:save_podtv, :save_plat, :save_s4et, :summ, :get_ot4, :remove_platezhka, :remove_podtv, :remove_s4et]
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
          :tyroperator_pay => params['travel']['tyroperator_pay'],
          :tyroper_id => params['travel']['tyroper_id'],
          :tyroper_type => params['travel']['tyroper_type']
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

   ###############
   def save_podtv_tyr
     @podtv_tyr = Attachment.new
     @podtv_tyr.uploaded_file = params[:file][:uploaded_data]
     @podtv_tyr.travel_id = params[:id]
     if @podtv_tyr.save
       @travel_tyr = Travel.update(params[:id],{ :podtv_tyr => @podtv_tyr.id })
       flash[:notice] = "Подтверждение оплаты сохранено"
     else
       flash[:error] = "Ошибка! подтверждение не сохранено!"
     end
     redirect_to :back
   end

   def save_s4et_tyr
     @podtv_tyr = Attachment.new
     @podtv_tyr.uploaded_file = params[:file][:uploaded_data]
     @podtv_tyr.travel_id = params[:id]
     if @podtv_tyr.save
       @travel_tyr = Travel.update(params[:id],{ :s4et_tyr => @podtv_tyr.id })
       flash[:notice] = "Подтверждение оплаты сохранено"
#       render :partial => 'travel/link_s4et'
     else
       flash[:error] = "Ошибка! подтверждение не сохранено!"
     end
     redirect_to :back
   end

   def save_plat_tyr
       @platezhka_tyr = Attachment.new
       @platezhka_tyr.uploaded_file = params[:file][:uploaded_data]
       @platezhka_tyr.travel_id = params[:id]
       if @platezhka_tyr.save!
         Travel.update(params[:id],{ :platezhka_tyr => @platezhka_tyr.id })
        flash[:notice] = "Платежка сохранена" 
#         render :file => 'travel/_link_platezhka.html.erb'
       else
         render :text => "Ошибка! платежка не сохранена!"
       end        
       redirect_to :back
   end

   ###############

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

   def remove_podtv_tyr
     @travel = Travel.find(params[:id])
     Attachment.delete(@travel.podtv_tyr)
     @travel.podtv_tyr = nil
     @travel.save!
     redirect_to :back
   end

   def remove_s4et_tyr
     @travel = Travel.find(params[:id])
     Attachment.delete(@travel.s4et_tyr)
     @travel.s4et_tyr = nil
     @travel.save!
     redirect_to :back
   end

   def remove_platezhka_tyr
     @travel = Travel.find(params[:id])
     Attachment.delete(@travel.platezhka_tyr)
     @travel.platezhka_tyr = nil
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
#     @tid.each {|x| @summa += (x.cena - x.tyroperator_pay) }
     @tid.each do |x|
       if x.cena == x.predoplata + x.doplata
         @summa += (x.cena - x.tyroperator_pay)
       end
     end

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

   def view
     @travel = Travel.find(params[:id])
     @month = month_ru(@travel.created_at.mon)
     @users = []
     @users << @travel.tourist
     if @travel.tourists_array
       @users << Tourist.find(@travel.tourists_array) 
     end
     @start_date = @travel.travelpoint.minimum('date_start')
     @end_date = @travel.travelpoint.maximum('date_end')
    render :partial => 'travel/template_zayavka', :layout => nil 

   end

   def get_zayavka_pdf
     @travel = Travel.find(params[:id])
     @users = []
     @users << @travel.tourist
     if @travel.tourists_array
       @users << Tourist.find(@travel.tourists_array)
     end
     @start_date = @travel.travelpoint.minimum('date_start')
     @end_date = @travel.travelpoint.maximum('date_end')
     pdf = Prawn::Document.new( :size => "A4", :page_layout => :portrait, :right_margin => 0.2 )
     pdf.font("#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf")

   end

   def get_zayavka_rtf # генерить будем сразу и договор и заявку в odf
     @travel = Travel.find(params[:id])
     @c = Customer.first
     @users = []
     @users << @travel.tourist
     if @travel.tourists_array
       @users << Tourist.find(@travel.tourists_array)
     end
     @start_date = @travel.travelpoint.minimum('date_start')
     @end_date = @travel.travelpoint.maximum('date_end')
     ODF::SpreadSheet.file("public/files/zayavka#{@travel.id}.ods") do |spreadsheet|
       spreadsheet.style 'red-cell', :family => :cell do |style|
         style.property :text, 'font-weight' => 'bold', 'color' => '#ff0000'
       end
       spreadsheet.style 'cust2', :family => :cell do |style|
         style.property :cell, 'border' => '0.0038in solid #000000'
       end
         

       spreadsheet.table '' do |table|
         table.row do |row|  
           row.cell ''
           row.cell ''
           row.cell "Приложение №1 к договору #{@travel.id} от \"#{@travel.created_at.mday}\" #{month_ru(@travel.created_at.mon)} #{@travel.created_at.year}г.", :number_columns_spanned => 4
         end
         table.row.cell 'г.Калининград' ,:number_columns_spanned => 2
         table.row
         table.row do |row|
           row.cell 'Сторона, именуемая в договоре "Турагент": ' + @c.name + "\n" + @c.yur_adress + "\n" + @c.fiz_adress + "\n" + @c.phone + ' ОГРН ' + @c.ogrn + "\n ИНН/КПП "+ @c.inn + '/' + @c.kpp + "\n" + @c.r_s4 + "\n"+ @c.bank + "\n" + @c.bik + "\n" + @c.director,  :number_columns_spanned => 7
         end
         table.row do |row|
           row.cell 'Сторона, именуемая в договоре "Турист": ' + @travel.tourist.surname_kir + ' ' + @travel.tourist.name_kir + ' ' + @travel.tourist.ot4_kir + "\n", :number_columns_spanned => 7
         end
         table.row
         table.row do |row|
           row.cell ''
           row.cell ''
           row.cell 'ЗАЯВКА НА БРОНИРОВАНИЕ ТУРПРОДУКТА', :number_columns_spanned => 4
         end
         table.row.cell '1. ТУРИСТЫ:'
         table.row do |row|
           row.cell "ФИО + (транскрипция в загран\nпаспорте гражданина РФ для \nвыезда из РФ и въезда в РФ)", :number_columns_spanned => 2, :style => 'cust2', :number_rows_spanned => 2
           row.cell
           row.cell 'Дата рождения', :style => 'cust2', :number_rows_spanned => 2
           row.cell 'Паспорт', :number_columns_spanned => 2, :style => 'cust2'
           row.cell 
           row.cell "Продолжительность \nпутешествия*", :number_columns_spanned => 2, :style => 'cust2'
           row.cell
         end
         table.row do |row|
           row.cell ''
           row.cell ''
           row.cell ''
           row.cell 'серия, N', :style => 'cust2'
           row.cell 'действует до', :style => 'cust2'
           row.cell 'начало', :style => 'cust2'
           row.cell 'окончание', :style => 'cust2'
         end
         @users.each do |t|
           table.row do |row|
             row.cell t.surname_kir + ' ' + t.name_kir + ' ' + t.ot4_kir + " \n " + t.surname_lat + ' ' + t.name_lat, :number_columns_spanned => 2, :style => 'cust2'
             row.cell 
             row.cell t.borndate, :style => 'cust2'
             row.cell t.seriya_zag_pasp.to_s + ' ' + t.nomer_zag_pasp.to_s, :style => 'cust2'
             row.cell t.actual_date_zag, :style => 'cust2'
             row.cell @start_date, :style => 'cust2'
             row.cell @end_date, :style => 'cust2'
           end
         end

         table.row.cell '2. Размещение по маршруту:'

         table.row do |row|
           row.cell 'Страна', :style => 'cust2'
           row.cell 'Город', :style => 'cust2'
           row.cell "Отель/категория\n(по каталогу ТО)", :style => 'cust2'
           row.cell "Период пребывания (с-по)", :style => 'cust2', :number_columns_spanned => 2
           row.cell
           row.cell 'Тип номера', :style => 'cust2'
           row.cell 'Питание', :style => 'cust2'
         end
         @travel.travelpoint.each do |x|
           table.row do |row|
             row.cell x.country.name , :style => 'cust2'
             row.cell x.city.name , :style => 'cust2'
             row.cell x.hotel.name , :style => 'cust2'
             row.cell x.date_start.to_s + " - "+ x.date_end.to_s , :style => 'cust2', :number_columns_spanned => 2
             row.cell
             row.cell x.roomtype.name , :style => 'cust2'
             row.cell x.foodtype.name , :style => 'cust2'
           end
         end
         table.row
         table.row.cell '3. Услуги: 3.1. Турпродукт: '
         table.row do |row| 
           row.cell 'Наим.', :style => 'cust2'
           row.cell 'Описание', :style => 'cust2', :number_columns_spanned => 5
           row.cell ; row.cell ; row.cell; row.cell ;
           row.cell "Количество\n туристов", :style => 'cust2'
         end
         %w(Перевозка Трансфер Перевозка Страховка Трансфер).each do |x|
           table.row do |row|
             row.cell x , :style => 'cust2'
             row.cell '' , :number_columns_spanned => 5, :style => 'cust2'
             row.cell ; row.cell ; row.cell; row.cell ;
             row.cell '', :style => 'cust2'
           end
         end
         table.row
         table.row.cell '3.2. Доп. услуги:'
         table.row do |row|
           row.cell 'Описание', :style => 'cust2', :number_columns_spanned => 5
           row.cell ; row.cell ; row.cell; row.cell ;
           row.cell 'Количество', :style => 'cust2'
           row.cell 'Цена', :style => 'cust2'
         end
         table.row
         table.row.cell '3.3. Примечания: '
         table.row.cell  '', :style => 'cust2', :number_columns_spanned => 7, :number_rows_spanned => 2
         table.row
         table.row.cell '4. Общая стоимость турпродукта (в рублях): '
         ['Общая цена турпродукта составляет:','Стоимость доп.услуг составляет:','Скидка (Внимание! Скидки на дополнительные оплаты не распространяются): ','Предоплата (не менее 50%): ','Общая стоимость турпродукта составляет:','Полная оплата турпродукта производится в срок до:'].each do |x|
           table.row do |row|
             row.cell x , :number_columns_spanned => 6, :style => 'cust2'
             row.cell ; row.cell ; row.cell; row.cell ; row.cell ;
             row.cell '', :style => 'cust2'
           end
         end
         table.row
         table.row.cell '6. Дополнительно: '
         ['Встречи:','Проводы:','Сопровождение:',"Минимальное количество человек в группе, необходимое для совершения\n путешествия (по условиям групповых и экскурсионных\n программ туроператора)"].each do |x|
           table.row do |row|
             row.cell x, :number_columns_spanned => 5, :style => 'cust2'
             row.cell ; row.cell ; row.cell; row.cell ;
             row.cell '', :number_columns_spanned => 2, :style => 'cust2'
             row.cell
           end
         end
         table.row
         table.row.cell '8. Турист заявляет о том, что: '
         ['8.1. С правилами страхования от невыезда ознакомлен(а):','а) Согласен (согласна) оформить страховку от невыезда:','б) Отказываюсь оформить страховку от невыезда:',"7.2. С информацией о стране пребывания, условиях и особенностях\n осуществления путешествия, правилами безопасности и\n поведения в стране пребывания ознакомлен(а)","7.3. Информацию о финансовом обеспечении туроператора\n, основаниях и порядке выплаты страхового возмещения или уплаты\n денежной суммы по банковской гарантии получил(а)"].each do |x|
           table.row do |row|
             row.cell x, :number_columns_spanned => 6, :style => 'cust2'
             row.cell ; row.cell ; row.cell; row.cell ;row.cell ;
             row.cell 'Подпись:', :style => 'cust2'
           end
         end
         table.row
         table.row do |row|
           row.cell 'Турагент: '
           row.cell ; row.cell ; row.cell ; row.cell;
           row.cell 'Турист:'
         end
         table.row do |row|
           row.cell '____________/' + @c.director + "/"
           row.cell ; row.cell ; row.cell;
           row.cell '____________/' + "#{@travel.tourist.surname_kir}" +"/"
         end
         table.row.cell 'М.П.'
       end
     end
     send_file "public/files/zayavka#{@travel.id}.ods"
#       File.delete "public/files/zayavka#{@travel.id}.ods"
   end

   def get_dogovor_ods
     @travel = Travel.find(params[:id])
     @c = Customer.first

     ODF::SpreadSheet.file("public/files/dogovor#{@travel.id}.ods") do |spreadsheet|
#       spreadsheet.style 'red-cell', :family => :cell do |style|
#         style.property :cell ,  'table:number-columns-spanned' => 2, 'table:number-rows-spanned' => 1
#       end
#       spreadsheet.style 'cust2', :family => :cell do |style|
#         style.property :cell, 'border' => '0.0138in solid #000000'
#       end
       spreadsheet.table 'Договор' do |table|
         table.row do |row|
           row.cell 
           row.cell
           row.cell
           row.cell "ДОГОВОР №#{@travel.id}", :number_columns_spanned => 3 
         end
         table.row
         table.row do |row|
           row.cell 'г. Калининград' , :number_columns_spanned => 2
           row.cell ''
           row.cell ''
           row.cell ''
           row.cell ''
           row.cell 'от "'+"#{@travel.created_at.mday}"+'”'+"#{month_ru(@travel.created_at.mon)} #{@travel.created_at.year}г."
         end
         table.row
         table.row do |row|
           row.cell "Сторона, именуемая в Договоре «Турагент»: #{@c.director}", :number_columns_spanned => 8
         end
         table.row.cell "Сторона, именуемая в Договоре «Турист»: #{@travel.tourist.surname_kir + " " + @travel.tourist.name_kir + " " + @travel.tourist.ot4_kir},паспорт \n гражданина РФ #{@travel.tourist.pasport_ros}, адрес местожительства: _______________________________________________ тел. #{@travel.tourist.phone}" , :number_columns_spanned => 8
         @@f = File.open('app/views/travel/_dogovor.html.erb')
         @@f.each_line do |str|
           if str =~ /^zzzZZZ/
             table.row do |row|
             row.cell 
             row.cell
             row.cell str.sub(/^zzzZZZ/, ''), :number_columns_spanned => 5
             end
           else
             table.row.cell str, :number_columns_spanned => 8
           end
         end
         @@f.close
         table.row.cell "____________________ /#{@travel.tourist.surname_kir}/              ____________________/#{@c.director}/", :number_columns_spanned => 8
         table.row.cell '                  М.П.'
       end
     end
     send_file "public/files/dogovor#{@travel.id}.ods"
   end

end
