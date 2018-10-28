require './libs/encryption.rb'

# Creates the signing configuration for the build. 
#
# @param folder Folder of the certificate and provisioning profile
# @param key Decryption key for the certificate and provisioning profile
def create_signing_configuration(folder, key)
  decrypt(folder, key)

  keychain_name = 'ios_build.keychain'
  keychain_password = key # only for temporary use

  create_keychain({
    name: keychain_name,
    password: keychain_password,
  })

  unlock_keychain({
    path: FastlaneCore::Helper.keychain_path(keychain_name),
    add_to_search_list: true,
    set_default: true,
    password: keychain_password
  })

  import_certificates_in_keychain(
    folder, 
    FastlaneCore::Helper.keychain_path(keychain_name), 
    keychain_password
  )

  copy_mobile_provisioning_profiles(folder)
end

# Imports certificates from a folder to the keychain
#
# @param folder Folder of the certificate and provisioning profile
# @param keychain_path Path for the temporary keychain
# @param keychain_password Password for the temporary keychain
def import_certificates_in_keychain(folder, keychain_path, keychain_password)
  supported_extensions = [".p12", ".cer"]

  Find.find(folder) do |file|
    next if !supported_extensions.include?(File.extname(file))

    puts "import: " + file

    FastlaneCore::KeychainImporter.import_file(
      file, 
      keychain_path,
      keychain_password: keychain_password, 
      output: FastlaneCore::Globals.verbose?)
  end
end

# Copies mobile provisioning profiles from a folder to the Provisioning Profiles folder
#
# @param folder Folder of the certificate and provisioning profile
def copy_mobile_provisioning_profiles(folder)
  supported_extensions = [".mobileprovision"]

  Find.find(folder) do |file|
    next if !supported_extensions.include?(File.extname(file))
    basename = File.basename(file)

    FileUtils.mkdir_p("#{Dir.home}/Library/MobileDevice/Provisioning\ Profiles/")
    FileUtils.cp(file, "#{Dir.home}/Library/MobileDevice/Provisioning\ Profiles/#{basename}")
  end
end

# Removes the temporary keychain
def remove_keychain
  keychain_name = 'ios_build.keychain'

  delete_keychain ({
    name: keychain_name
  })
end

# Deletes encrypted certificates for a configuration
#
# @param configuration Configuration for the build
def delete_certificates(folder)
  supported_extensions = [".p12", ".cer"]

  Find.find(folder) do |file|
    next if !supported_extensions.include?(File.extname(file))

    FileUtils.rm(file)
  end
end

# Deletes encrypted mobile provisioning profiles
#
# @param configuration Configuration for the build
def delete_mobile_provisioning_profiles(folder)
  supported_extensions = [".mobileprovision"]

  Find.find(folder) do |file|
    next if !supported_extensions.include?(File.extname(file))

    FileUtils.rm(file)
  end
end

# Clears the signing configuration and deletes the certificates, profiles and keychains
#
# @param configuration Configuration for the build
def clear_signing_configuration(folder)
  delete_certificates(folder)
  delete_mobile_provisioning_profiles(folder)
  remove_keychain
end
