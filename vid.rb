# coding:utf-8
require 'active_record'
require 'sinatra'
require 'sinatra/reloader'
require 'logger'

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection(:development)
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Work < ActiveRecord::Base
	has_many :scenes
end

class Scene < ActiveRecord::Base
	belongs_to :work
	has_many :shots
end

class Shot < ActiveRecord::Base
	belongs_to :scene
end

helpers do
  def highlight(text, keywords)
    keywords.each { |kw|
      text.gsub!(/#{kw}/) {|kw| "<span style='background: yellow;'>#{kw}</span>" }
    }
    "#{text}"
  end
end

#get '/' do
#	erb :index
#end

get '/work_search' do
	erb :work_search
end

post '/work_search_result' do
	@title = "RESULT"
	@keywords = params["keyword"].gsub(/　/," ").split()
    @results = Work.select('works.*')
	@keywords.each {|keyword|
		@results = @results.where("title like?", "%#{keyword}%")
							 }
    erb :work_result_list
end

post '/vplay' do
	@idt = params["idt"]
	@title = params["title"]
	@des = params["description"]
	@creator = params["creator"]
	@publisher = params["publisher"]
	@duration = params["duration"]
	erb :vplay
end


get '/scene_search' do
	erb :scene_search
end

post '/scene_search_result' do
	@title = "RESULT"
	@keywords = params["keyword"].gsub(/　/," ").split()
	@results = Scene.select('scenes.*, scenes.id AS sid, works.*, works.id AS wid, scenes.description AS sdesc, scenes.format_length AS sfl, scenes.type_lev AS lev_scene').joins('INNER JOIN works ON works.id = work_id')
	@keywords.each{|keyword|
		@results = @results.where("scenes.description like?", "%#{keyword}%")
	}
	erb :scene_result_list
end

post '/vplay_scene' do
	@id = params["id"]
	@des = params["description"]
	@title = params["title"]
	@contributor = params["contributor"]
	@creator = params["creator"]
	@publisher = params["publisher"]
	@lang = params["lang"]
	@level = params["level"]
	@duration = params["duration"]
	@ctmn_h = params["ctmn_hour"]
	@ctmn_m = params["ctmn_min"]
	@ctmn_s = params["ctmn_sec"]
	@ctmx_h = params["ctmx_hour"]
	@ctmx_m = params["ctmx_min"]
	@ctmx_s = params["ctmx_sec"]
	erb :vplay_shot
end

get '/shot_search' do
	erb :shot_search
end

#post '/shot_search_result' do
#	@title = "RESULT"
#	@keyword = params["keyword"]
#	@results = Shot.where("description like?", "%#{@keyword}%")
#	erb :shot_result_list
#end
post '/shot_search_result' do
	@title = "RESULT"
	@keywords = params["keyword"].gsub(/　/," ").split()
	@results = Shot.select('shots.*, shots.id AS shid, shots.description AS dsc_sh, shots.type_lev AS type_lev_sh, shots.format_length AS format_length_sh, shots.ctmx_hour AS ctmx_hour_sh, shots.ctmx_min AS ctmx_min_sh, shots.ctmx_sec AS ctmx_sec_sh, shots.ctmn_hour AS ctmn_hour_sh, shots.ctmn_min AS ctmn_min_sh, shots.ctmn_sec AS ctmn_sec_sh, scenes.*, scenes.id AS scid,scenes.description AS dsc_sc, scenes.type_lev AS type_lev_sc, scenes.format_length AS format_length_sc, works.*').joins('INNER JOIN scenes ON scenes.id = shots.scene_id').joins('INNER JOIN works ON works.id = shots.work_id')
	@keywords.each {|keyword|
		@results = @results.where("shots.description like?", "%#{keyword}%")
	}
	erb :shot_result_list
end


post '/vplay_shot' do
	@id = params["id"]
	@des = params["description"]
	@title = params["title"]
	@contributor = params["contributor"]
	@creator = params["creator"]
	@publisher = params["publisher"]
	@lang = params["lang"]
	@level = params["level"]
	@duration = params["duration"]
	@ctmn_h = params["ctmn_hour"]
	@ctmn_m = params["ctmn_min"]
	@ctmn_s = params["ctmn_sec"]
	@ctmx_h = params["ctmx_hour"]
	@ctmx_m = params["ctmx_min"]
	@ctmx_s = params["ctmx_sec"]
	erb :vplay_shot
end
