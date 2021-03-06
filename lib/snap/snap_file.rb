module Snap
  class SnapFile
    def initialize(file_name)
      @path = file_name.sub("//", "/")
    end
  
    def name
      if @path && @path.match("/")
        @path.split("/").last
      else
        @path
      end
    end
    
    def path
      @path
    end
    
    def relative_to(dir)
      rel = @path.sub(dir, "")
    end

    def size
      File.size(@path)
    end

    def mtime
      return if File.symlink?(@path)
      mtime = File.mtime(@path)
      if (mtime.to_i > Time.now.to_i - 24*60*60)
        mtime.strftime("%I:%M:%S %p")
      else
        mtime.strftime("%d-%m-%Y")      
      end
    end
    
    def type
      type = Rack::Mime::MIME_TYPES[File.extname(path)]
           
      if type.nil? 
        escaped_path = @path.gsub(" ", "\\ ")
        type = `file #{escaped_path}`.strip.sub(/.*:\s*/, "")
        type = "executable"       if type.match("executable")
      end
      type
    end
    
    # TODO: Get this HTML outta here
    def icon
      return "<img src=\"/__snap__/icons/dir.png\"/>" if directory?
      return "<img src=\"/__snap__/icons/image.png\"/>" if image?
      return "<img src=\"/__snap__/icons/text.png\"/>"
    end
    
    def image?
      type.match("image")
    end
    
    def directory?
      type.match("directory")
    end
  end
end