require 'rake/clean'

def version
    File.read('VERSION').strip
end

def iced taskname, dst, src
    task taskname => [dst]
    CLOBBER << dst
    file dst => [src] do
        sh 'node_modules/.bin/iced', '-I', 'inline', '-c', '-o', File.dirname(dst), src
    end
end

def stylus taskname, dst, src
    task taskname => [dst]
    CLOBBER << dst
    file dst => [src] do
        sh 'node_modules/.bin/stylus', '-c', '-o', File.dirname(dst), src
    end
end

def verbatim taskname, dst, src
    task taskname => [dst]
    CLOBBER << dst
    file dst => [src] do
        cp src, dst
    end
end

def zip taskname, dst, src
    task taskname => [dst]
    CLOBBER << dst

    file dst => Dir["#{src}/**"] do
        dst = File.expand_path(dst)
        Dir.chdir File.dirname(src) do
            rm dst if File.file?(dst)
            sh 'zip', '-9r', dst, File.basename(src)
        end
    end
end


# Building

verbatim   :default, 'extensions/Safari/BetterUserVoice.safariextension/jquery.js', 'vendor/jquery.js'
iced       :default, 'extensions/Safari/BetterUserVoice.safariextension/BetterUserVoice.js', 'src/BetterUserVoice.iced'
stylus     :default, 'extensions/Safari/BetterUserVoice.safariextension/BetterUserVoice.css', 'src/BetterUserVoice.styl'

verbatim   :default, 'extensions/Chrome/BetterUserVoice/jquery.js', 'vendor/jquery.js'
iced       :default, 'extensions/Chrome/BetterUserVoice/BetterUserVoice.js', 'src/BetterUserVoice.iced'
stylus     :default, 'extensions/Chrome/BetterUserVoice/BetterUserVoice.css', 'src/BetterUserVoice.styl'


# Distribution

zip :dist, "dist/#{version}/BetterUserVoice-#{version}-Chrome.zip", 'extensions/Chrome/BetterUserVoice'

desc "Upload Safari extension, zip and upload Chrome extension"
task 'dist' do
    upload_file "dist", "#{version}/BetterUserVoice-#{version}-Chrome.zip"
    upload_file "dist", "#{version}/BetterUserVoice-#{version}.safariextz"
end



# Uploading

def upload_file folder, file
    sh 's3cmd', '-P', '--mime-type=application/octet-stream', 'put', "#{folder}/#{file}", "s3://files.tarantsov.com/BetterUserVoice/#{file}"
    puts "http://files.tarantsov.com/BetterUserVoice/#{file}"
end

desc "Upload Safari update manifest"
task 'manifest' do
    upload_file 'update', "BetterUserVoice-Safari-update.plist"
end



# Versions

VERSION_FILES = %w(
    extensions/Safari/BetterUserVoice.safariextension/Info.plist
    extensions/Chrome/BetterUserVoice/manifest.json
    update/BetterUserVoice-Safari-update.plist
)

def subst_version_refs_in_file file, ver
    puts file
    orig = File.read(file)
    prev_line = ""
    anything_matched = false
    data = orig.lines.map do |line|
        if line =~ /\d{1,2}\.\d{1,2}\.\d{1,2}/ && (line =~ /version|http:/i || prev_line =~ /CFBundleShortVersionString|CFBundleVersion/)
            anything_matched = true
            new_line = line.gsub /\d\.\d\.\d/, ver
            puts "    #{new_line.strip}"
        else
            new_line = line
        end
        prev_line = line
        new_line
    end.join('')

    raise "Error: no substitutions made in #{file}" unless anything_matched

    File.open(file, 'w') { |f| f.write data }
end

desc "Embed version number where it belongs"
task :version do
    ver = version
    VERSION_FILES.each { |file| subst_version_refs_in_file(file, ver) }
    mkdir_p "dist/#{version}"
    Rake::Task[:default].invoke
end

desc "Tag the current version"
task :tag do
    sh 'git', 'tag', "v#{version}"
end

desc "Move (git tag -f) the tag for the current version"
task :retag do
    sh 'git', 'tag', '-f', "v#{version}"
end
